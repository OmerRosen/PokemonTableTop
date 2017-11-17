from __future__ import unicode_literals
from django.template import loader
from mysite import ImportModules

import pyodbc

from django.shortcuts import render

# Create your views here.

def TestPages(request):
    return render(request, 'battles/testpage.html')