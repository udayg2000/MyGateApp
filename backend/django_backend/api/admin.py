# from django.contrib import admin
# from .models import * 

# admin.site.register(Location)
# admin.site.register(Department)
# admin.site.register(Program)
# admin.site.register(Hostel)
# admin.site.register(Person)
# admin.site.register(Password)
# admin.site.register(Student)
# admin.site.register(Guard)
# admin.site.register(Authorities)
# admin.site.register(AuthoritiesTicketTable)
# admin.site.register(TicketTable)
# admin.site.register(StatusTable)

from django.contrib import admin
from django.apps import apps
from django.contrib.admin.sites import AlreadyRegistered

app_models = apps.get_app_config('api').get_models()
for model in app_models:
    try:
        admin.site.register(model)
    except AlreadyRegistered:
        pass