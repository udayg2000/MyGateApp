import requests

base_url = 'http://localhost:'
port_num = '8000/'
start_url = base_url + port_num

end_point = 'clear_db'
url = start_url + end_point
r = requests.post(url, data={})

end_point = 'init_db'
url = start_url + end_point
r = requests.post(url, data={})

file_name = 'Department.csv'
with open(file_name, 'rb') as f:
    end_point = 'files/add_departments_from_file'
    url = start_url + end_point
    r = requests.post(url, files={'file': f})

file_name = 'Program.csv'
with open(file_name, 'rb') as f:
    end_point = 'files/add_programs_from_file'
    url = start_url + end_point
    r = requests.post(url, files={'file': f})

file_name = 'Hostel.csv'
with open(file_name, 'rb') as f:
    end_point = 'files/add_hostels_from_file'
    url = start_url + end_point
    r = requests.post(url, files={'file': f})

file_name = 'Location.csv'
with open(file_name, 'rb') as f:
    end_point = 'files/add_locations_from_file'
    url = start_url + end_point
    r = requests.post(url, files={'file': f})

file_name = 'Authorities.csv'
with open(file_name, 'rb') as f:
    end_point = 'files/add_authorities_from_file'
    url = start_url + end_point
    r = requests.post(url, files={'file': f})

file_name = 'Guard.csv'
with open(file_name, 'rb') as f:
    end_point = 'files/add_guards_from_file'
    url = start_url + end_point
    r = requests.post(url, files={'file': f})

file_name = 'Students.csv'
with open(file_name, 'rb') as f:
    end_point = 'files/add_students_from_file'
    url = start_url + end_point
    r = requests.post(url, files={'file': f})

end_point = 'forms/add_admin_form'
url = start_url + end_point
r = requests.post(url, data={'name': 'Admin', 'email':'admin@gmail.com'})

