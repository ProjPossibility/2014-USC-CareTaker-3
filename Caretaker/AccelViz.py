from tkinter import Tk, Canvas, Frame, BOTH
import sys

class Example(Frame):
  
    dataXArray = []
    dataYArray = []
    dataZArray = []
    zippedDataArray = []

    canvasWidth = 1280
    canvasHeight = 720

    def __init__(self, parent, filestring):
        Frame.__init__(self, parent)   
         
        self.parent = parent        
        self.readDataFromFile(filestring)
        self.initUI()
        
    def initUI(self):
      
        self.parent.title("Colors")        
        self.pack(fill=BOTH, expand=1)

        canvas = Canvas(self)

        #bounds = canvas.bbox(canvas)  # returns a tuple like (x1, y1, x2, y2)
        #width = canvas.width #bounds[2] - bounds[0]
        #height = canvas.height #bounds[3] - bounds[1]

        size = len(self.dataXArray)

        graphHeight = 100
        graphOriginX = 0
        graphOriginY = self.canvasHeight / 2
        graphScaleX = self.canvasWidth / size

        #canvas.create_line(graphOriginX, graphOriginY - int(graphHeight), graphOriginX + (graphScaleX * (size + 1)), graphOriginY - int(graphHeight), fill="black")
        #canvas.create_line(graphOriginX, graphOriginY + int(graphHeight), graphOriginX + (graphScaleX * (size + 1)), graphOriginY + int(graphHeight), fill="black")
        canvas.create_line(graphOriginX, graphOriginY, graphOriginX + (graphScaleX * (size + 1)), graphOriginY, fill="black")
                

        for i in range(0, len(self.zippedDataArray) - 1):
            canvas.create_line(graphOriginX + (graphScaleX * i), graphOriginY - int(graphHeight * self.dataXArray[i]), graphOriginX + (graphScaleX * (i + 1)), graphOriginY - int(graphHeight * self.dataXArray[i + 1]), fill="red")
            canvas.create_line(graphOriginX + (graphScaleX * i), graphOriginY - int(graphHeight * self.dataYArray[i]), graphOriginX + (graphScaleX * (i + 1)), graphOriginY - int(graphHeight * self.dataYArray[i + 1]), fill="green")
            canvas.create_line(graphOriginX + (graphScaleX * i), graphOriginY - int(graphHeight * self.dataZArray[i]), graphOriginX + (graphScaleX * (i + 1)), graphOriginY - int(graphHeight * self.dataZArray[i + 1]), fill="blue")
            if i % 10 == 0:
                canvas.create_line(graphOriginX + (graphScaleX * i), graphOriginY - int(graphHeight), graphOriginX + (graphScaleX * (i)), graphOriginY + int(graphHeight), fill="black")



#        canvas.create_rectangle(270, 10, 370, 80, 
#            outline="#05f", fill="#05f")            
        canvas.pack(fill=BOTH, expand=1)


    def readDataFromFile(self, filename):
        try:
            print("Opening File: {0}".format(filename))
            file = open(filename, 'r')
            file.seek(0, 2)
            fileLength = file.tell()
            file.seek(0, 0)
        
        
            for i in range(0, fileLength):
                line = file.readline()
                if i == 0:
                    continue
                if(line.find('/') == -1):
                    print("Format Error, lacking slash")
                    print(line)
                    break
                entries = line.split('/')
                self.dataXArray.append(float(entries[0]))
                self.dataYArray.append(float(entries[1]))
                self.dataZArray.append(float(entries[2]))
            
                self.zippedDataArray = list(zip(self.dataXArray, self.dataYArray, self.dataZArray))
        except FileNotFoundError:
            print("file not found!")
            exit()
        




def main():

    filename = sys.argv[1]
  
    root = Tk()
    ex = Example(root, filename)
    root.geometry("1280x720+100+100")
    root.mainloop()  


if __name__ == '__main__':
    main()
