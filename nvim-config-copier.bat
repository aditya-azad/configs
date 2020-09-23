robocopy C:\Users\aditya\AppData\Local\nvim\init.vim .\configs\.config\nvim\
robocopy C:\Users\aditya\AppData\Local\nvim\snips\* .\configs\configs\.config\nvim\snips\* /E
git commit -a -m "Updated nvim config"
git push
