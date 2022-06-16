from django.apps import AppConfig
import os

class ApiConfig(AppConfig):
    default_auto_field = 'django.db.models.BigAutoField'
    name = 'api'
    
    def ready(self):
        return
        # print("os.environ.get('RUN_MAIN', None): " + os.environ.get('RUN_MAIN', None))
        # if os.environ.get('RUN_MAIN', None) == 'true':
        #     return
        run_once = os.environ.get('CMDLINERUNNER_RUN_ONCE') 
        if run_once is not None:
            return
        os.environ['CMDLINERUNNER_RUN_ONCE'] = 'True' 
        try:
            from .thread import AutomaticExitThread            
            AutomaticExitThread().start()
        except:
            pass
