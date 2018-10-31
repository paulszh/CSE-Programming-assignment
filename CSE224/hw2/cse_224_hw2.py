import socket
HOST = 'cse224.sysnet.ucsd.edu'
PORT = 5555
PID = 'A99086018\r\n'

try: 
    HOST_IP = socket.gethostbyname(HOST)
    print (HOST_IP)
except socket.gaierror:
    print ("There was an error to get host ip address")
    sys.exit()


with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s: 
    s.connect((HOST_IP, PORT))
    s.sendall(PID.encode())
    print ('Start receiving data')
    while True:
        data = s.recv(1024)
        print (repr(data))
        if not data:
            break




