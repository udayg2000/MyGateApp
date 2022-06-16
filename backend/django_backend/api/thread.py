import threading
from time import sleep
from .models import *
from .serializers import *
from datetime import datetime
from rest_framework.response import Response
from rest_framework import status

initial_data = 'initial_data'

class AutomaticExitThread(threading.Thread):
    
    def __init__(self):        
        self.AUTOMATIC_EXIT_CHECK_INTERVAL = 60 # sleep duration
        self.AUTOMATIC_EXIT_TIME = 45 # in minutes 45 minutes
        threading.Thread.__init__(self)
  
    def calculate_time_difference(self, time1, time2):
        time1_hour = int(time1.split(":")[0])
        time1_minute = int(time1.split(":")[1])
        
        time2_hour = int(time2.split(":")[0])
        time2_minute = int(time2.split(":")[1])

        time_difference = 60*(time1_hour-time2_hour) + (time1_minute - time2_minute)

        return time_difference
    
    def run(self):    
        iteration = 1
        try:
            while(True):
                print("Automatic Exit Checked: " + str(iteration) + "\n")
                queryset_locations = Location.objects.filter(is_present = True, automatic_exit_required = True)
                
                serializer_location = LocationSerializer(queryset_locations, many = True)
                
                for each_location in serializer_location.data:
                    if each_location['location_name'] == initial_data:
                        continue
                    
                    location_id = each_location['location_id']
                    
                    queryset_status_table = StatusTable.objects.filter(is_present = True, location_id = location_id)
                    serializer_status_table = StatusTableSerializer(queryset_status_table, many = True)
                    for each_status in serializer_status_table.data: 
                        entry_no = each_status['entry_no']
                        
                        queryset_ticket_table = TicketTable.objects.filter(
                            ticket_type = 'enter',
                            entry_no = entry_no,
                            location_id = location_id,
                            )
                        
                        serializer_ticket_table = TicketTableSerializer(queryset_ticket_table, many = True)
                        
                        if len(serializer_ticket_table.data) ==0:
                            continue

                        date_time_of_this_ticket = serializer_ticket_table.data[-1]['date_time']
                        
                        _date_of_ticket = date_time_of_this_ticket.split("T")[0]
                        
                        _time_of_ticket = ":".join((date_time_of_this_ticket.split("T")[-1]).split(".")[0].split(":")[:-1])
                        
                        now = datetime.now()
                        curr_date = now.strftime("%Y-%m-%d")
                        curr_time = now.strftime("%H:%M")

                        if(curr_date == _date_of_ticket):
                            time_difference = self.calculate_time_difference(curr_time, _time_of_ticket)
                            if(time_difference>= self.AUTOMATIC_EXIT_TIME):
                                StatusTable.objects.filter(
                                    is_present = True, 
                                    location_id = location_id,
                                    entry_no = entry_no,
                                    ).update(current_status = 'out')
                        else:
                            StatusTable.objects.filter(
                                is_present = True, 
                                location_id = location_id,
                                entry_no = entry_no,
                                ).update(current_status = 'out')
                iteration += 1
                sleep(self.AUTOMATIC_EXIT_CHECK_INTERVAL)

            return Response(status= status.HTTP_200_OK)

        except Exception as e:
            print(e)
            return Response(status= status.HTTP_500_INTERNAL_SERVER_ERROR)

        
    