import sys
import os

Folder='E:\Dropbox\Pokemon Tabletop Project\Scripts'

print sys.path

if Folder not in sys.path:
    sys.path.append(Folder)

print sys.path

#import MergeToCSVTable

#print MergeToCSVTable.MergeCSVToTable(x,y,z)