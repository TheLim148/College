import time
from tkinter import *
from tkinter import ttk

def stop():
        btn_start.pack()
        btn_stop.pack_forget()

def sound():
        btn_start.pack_forget()
        btn_stop.pack()
        

def start():
        duration = int(seconds.get())
        while duration:
                mins, secs = divmod(int(duration),60)
                min_sec_format = '{:02d}:{:02d}'.format(mins, secs)
                count_digit.update()
                time.sleep(1)
                duration -= 1
        sound()                  


root = Tk()
root.title("timer")
root.geometry("250x150")
root.resizable(0,0)

count_digit = ttk.Label(root, text='0')
count_digit.pack()
 
seconds= ttk.Entry(root,width=7)
seconds.pack(pady=10)

btn_start = ttk.Button(root,text='старт', command=start)
btn_start.pack()

btn_stop = ttk.Button(root,text='занова', command=stop)
btn_stop.pack()

root.mainloop()

