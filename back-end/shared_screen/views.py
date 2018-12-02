from django.shortcuts import render
from content.models import Category



def index(request):
    catagory_list = Category.objects.order_by('id')[:5]
    context = {
        'catagory_list': catagory_list,
    }
    return render(request, 'session/index.html', context)