import sys
import os

Folder=r'E:\Pokemon Table Top\Git Project\PokemonTableTop\Scripts'

print sys.path
exit()
if Folder not in sys.path:
    sys.path.append(Folder)

print sys.path

#import MergeToCSVTable

#print MergeToCSVTable.MergeCSVToTable(x,y,z)