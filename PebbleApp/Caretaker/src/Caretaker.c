#include <pebble.h>

static Window *window;
static TextLayer *time_layer;

enum {
  CARETAKER_KEY_ACCEL_X = 0x01,
  CARETAKER_KEY_ACCEL_Y = 0x02,
  CARETAKER_KEY_ACCEL_Z = 0x03
};

char *translate_error(AppMessageResult result) {
  switch (result) {
  case APP_MSG_OK: return "APP_MSG_OK";
  case APP_MSG_SEND_TIMEOUT: return "APP_MSG_SEND_TIMEOUT";
  case APP_MSG_SEND_REJECTED: return "APP_MSG_SEND_REJECTED";
  case APP_MSG_NOT_CONNECTED: return "APP_MSG_NOT_CONNECTED";
  case APP_MSG_APP_NOT_RUNNING: return "APP_MSG_APP_NOT_RUNNING";
  case APP_MSG_INVALID_ARGS: return "APP_MSG_INVALID_ARGS";
  case APP_MSG_BUSY: return "APP_MSG_BUSY";
  case APP_MSG_BUFFER_OVERFLOW: return "APP_MSG_BUFFER_OVERFLOW";
  case APP_MSG_ALREADY_RELEASED: return "APP_MSG_ALREADY_RELEASED";
  case APP_MSG_CALLBACK_ALREADY_REGISTERED: return "APP_MSG_CALLBACK_ALREADY_REGISTERED";
  case APP_MSG_CALLBACK_NOT_REGISTERED: return "APP_MSG_CALLBACK_NOT_REGISTERED";
  case APP_MSG_OUT_OF_MEMORY: return "APP_MSG_OUT_OF_MEMORY";
  case APP_MSG_CLOSED: return "APP_MSG_CLOSED";
  case APP_MSG_INTERNAL_ERROR: return "APP_MSG_INTERNAL_ERROR";
  default: return "UNKNOWN ERROR";
  }
}

static void handle_second_tick(struct tm* tick_time, TimeUnits units_changed) {

  bool use24h = clock_is_24h_style(); 


  static char time_text[] = "00:00"; // Needs to be static because it's used by the system later.
  if(use24h)
  {
    strftime(time_text, sizeof(time_text), "%R", tick_time);
  }
  else
  {
    strftime(time_text, sizeof(time_text), "%I:%M", tick_time);
  }

  text_layer_set_text(time_layer, time_text);
}


static void select_click_handler(ClickRecognizerRef recognizer, void *context) {
  //text_layer_set_text(text_layer, "Select");
}

static void up_click_handler(ClickRecognizerRef recognizer, void *context) {
  //text_layer_set_text(text_layer, "Up");
}

static void down_click_handler(ClickRecognizerRef recognizer, void *context) {
  //text_layer_set_text(text_layer, "Down");
}

static void click_config_provider(void *context) {
  window_single_click_subscribe(BUTTON_ID_SELECT, select_click_handler);
  window_single_click_subscribe(BUTTON_ID_UP, up_click_handler);
  window_single_click_subscribe(BUTTON_ID_DOWN, down_click_handler);
}

static void window_load(Window *window) {
  Layer *window_layer = window_get_root_layer(window);
  GRect bounds = layer_get_bounds(window_layer); 
  window_set_background_color(window, GColorWhite);

  time_layer = text_layer_create((GRect) { .origin = { 0, 50 }, .size = { bounds.size.w, 80 } });
  text_layer_set_text_alignment(time_layer, GTextAlignmentCenter);
  //text_layer_set_font(time_layer, fonts_load_custom_font(resource_get_handle(RESOURCE_ID_FONT_ARIAL_BOLD_42)));
  text_layer_set_text_color(time_layer, GColorBlack);
  //text_layer_set_background_color(time_layer, GColorWhite);
  text_layer_set_font(time_layer, fonts_get_system_font(FONT_KEY_ROBOTO_BOLD_SUBSET_49));

  time_t now = time(NULL);
  struct tm *current_time = localtime(&now);
  handle_second_tick(current_time, SECOND_UNIT);
  tick_timer_service_subscribe(SECOND_UNIT, &handle_second_tick);

  layer_add_child(window_layer, text_layer_get_layer(time_layer));
}

static void window_unload(Window *window) {
  text_layer_destroy(time_layer);
}

static void accel_msg(float x, float y, float z) {
  APP_LOG(APP_LOG_LEVEL_DEBUG, "Prepping Msg");  

  Tuplet accel_x_tuple = TupletInteger(CARETAKER_KEY_ACCEL_X, (int)x);
  Tuplet accel_y_tuple = TupletInteger(CARETAKER_KEY_ACCEL_Y, (int)y);
  Tuplet accel_z_tuple = TupletInteger(CARETAKER_KEY_ACCEL_Z, (int)z);

  DictionaryIterator *iter;
  app_message_outbox_begin(&iter);

  if (iter == NULL) {
    return;
  }

  dict_write_tuplet(iter, &accel_x_tuple);
  dict_write_tuplet(iter, &accel_y_tuple);
  dict_write_tuplet(iter, &accel_z_tuple);
  dict_write_end(iter);

  AppMessageResult res = app_message_outbox_send();
  APP_LOG(APP_LOG_LEVEL_DEBUG, "Message Sent: X = %d, Y = %d, Z = %d   with status: %s", (int)(x), (int)(y), (int)(z), translate_error(res));
}

static void handle_accel(AccelData *accel_data, uint32_t num_samples) {
  APP_LOG(APP_LOG_LEVEL_DEBUG, "Received Accel Data with %d samples", (int)num_samples);
  
  for(uint32_t i = 0; i < num_samples; i++) {
    APP_LOG(APP_LOG_LEVEL_DEBUG, "Handling Accel Sample %u of %u", (int)i, (int)num_samples);
    if(accel_data->did_vibrate) {
      APP_LOG(APP_LOG_LEVEL_DEBUG, "Ignoring Message due to vibration");
      continue;
    }
    
    accel_msg((accel_data + i)->x, (accel_data + i)->y, (accel_data + i)->z);
  }
}


static void out_failed_handler(DictionaryIterator *failed, AppMessageResult reason, void *context) {
  APP_LOG(APP_LOG_LEVEL_DEBUG, "App Message Failed to Send!");
  APP_LOG(APP_LOG_LEVEL_DEBUG, "%s", translate_error(reason));  
}

static void app_message_init(void) {
  // Register message handlers
  //app_message_register_inbox_received(in_received_handler);
  //app_message_register_inbox_dropped(in_dropped_handler);
  app_message_register_outbox_failed(out_failed_handler);
  // Init buffers
  app_message_open(app_message_inbox_size_maximum(), app_message_outbox_size_maximum());
  //app_message_open(app_message_inbox_size_maximum(), 64);
  APP_LOG(APP_LOG_LEVEL_DEBUG, "MAXSIZE: %d", (int)app_message_outbox_size_maximum());
  accel_msg(0.0f, 0.0f, 0.0f);
}


static void init(void) {
  window = window_create();
  window_set_fullscreen(window, true);  
  window_set_click_config_provider(window, click_config_provider);
  window_set_window_handlers(window, (WindowHandlers) {
    .load = window_load,
    .unload = window_unload,
  });

  app_message_init();

  accel_service_set_sampling_rate(ACCEL_SAMPLING_10HZ);
  accel_data_service_subscribe(1, handle_accel);
  //timer = app_timer_register(100 /* milliseconds */, timer_callback, NULL);

  const bool animated = true;
  window_stack_push(window, animated);
}

static void deinit(void) {
  accel_data_service_unsubscribe();
  window_destroy(window);
}

int main(void) {
  init();

  APP_LOG(APP_LOG_LEVEL_DEBUG, "Done initializing, pushed window: %p", window);

  app_event_loop();
  deinit();
}
