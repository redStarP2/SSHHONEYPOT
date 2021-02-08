#!/usr/bin/python3

import threading
import socket
import sys
import paramiko
import time
import telnetlib
import time
import pymysql 
import IP2Location
import os


database = IP2Location.IP2Location("IP2LOCATION-LITE-DB5.BIN")
 


dbAddr = socket.gethostbyname("veritabani")
print(dbAddr)

shellAddr = socket.gethostbyname("shell")
print(shellAddr)

db = pymysql.connect(host=str(dbAddr),user="logs",password="OOU1tmUdCEt3kobx",database="logs" )
cursor = db.cursor()
HOST_KEY = paramiko.RSAKey(filename='private.key')
SSH_BANNER = "SSH-2.0-OpenSSH_8.2p1 Ubuntu-4ubuntu0.1"
fakeUser = ""





def logla(ip,data,login=0,username="",password=""):

    rec = database.get_all(str(ip))
    latitude  = rec.latitude
    longitude = rec.longitude
    if(login):
        print("[*] Username: "+str(username)+" Password: "+str(password) + " Zaman: "+str(int(time.time())))
        cursor.execute('INSERT INTO userPass(`ip`,`username`,`password`,`latitude`,`longitude`,`date`) VALUES(%s, %s, %s, %s, %s, %s)', (ip, username, password,latitude,longitude, str(int(time.time()))  )) 
        db.commit()
    else:
        print("[*] LOG: "+str(ip)+" KOMUT: "+str(data)+ " Zaman: "+str(int(time.time())))
        cursor.execute('INSERT INTO komutlar(`ip`,`komut`,`latitude`,`longitude`,`date`) VALUES( %s, %s, %s, %s, %s)', (ip, data,latitude,longitude, str(int(time.time()))  )) 
        db.commit()


def blackList(ip):
    a=ip



class FakeSshServer(paramiko.ServerInterface):
    user  = ""
    paswd = ""

    def __init__(self):
        self.event = threading.Event()

    def check_channel_request(self, kind, chanid):
        if kind == 'session':
            return paramiko.OPEN_SUCCEEDED
        return paramiko.OPEN_FAILED_ADMINISTRATIVELY_PROHIBITED

    def check_auth_password(self, username, password):
        self.user= username
        self.paswd = password
        return paramiko.AUTH_SUCCESSFUL

    def get_allowed_auths(self, username):
        return 'password'

    def check_channel_shell_request(self, channel):
        self.event.set()
        return True

    def check_channel_pty_request(self, channel, term, width, height, pixelwidth, pixelheight, modes):
        return True


def handle_connection(client, addr, sock):
    telnet = telnetlib.Telnet()
    telnet.open(shellAddr, 9000)
    try:
        transport = paramiko.Transport(client)
        transport.add_server_key(HOST_KEY)
        transport.local_version = SSH_BANNER
        server = FakeSshServer()
        try:
            transport.start_server(server=server)
        except paramiko.SSHException:
            print('*** SSH negotiation failed.')
            raise Exception("SSH negotiation failed")
        # wait for auth
        chan = transport.accept(20)
        if chan is None:
            print('*** Kanal yok ??')
            raise Exception("No channel")

        server.event.wait(10)
        if not server.event.is_set():
            print('*** Client shell istemedi')
            raise Exception("Bi gariplik var!")

        try:
            chan.send("Welcome Back FILESRV\r\n\r\n") 
            run = True
            logla(addr[0],"**CONNECTED**",1,username=server.user,password=server.paswd)
            chan.send(telnet.read_until(b"$ ").decode('utf-8').replace("\n","\r\n"))
            while run:
                command = ""
                while not command.endswith("\r"):
                    transport = chan.recv(1024)
                    command += transport.decode("utf-8") 
                    chan.send(transport)
                chan.send("\r\n")
                command = command.rstrip()
                logla(addr[0],str(command))
                if command == "exit":
                    chan.send("\r\nBye\r\n")
                    run = False
                    continue
                telnet.write(command.encode('ascii')+b"\n")
                response = telnet.read_until(b"$ ").decode('utf-8').replace("\n","\r\n")
                chan.send(response )
        except Exception as err:
            print(err)
            run = False
            try:
                transport.close()
            except Exception:
                pass
        chan.close()
    except Exception as err:
        try:
            transport.close()
        except Exception:
            pass


def start_server(port, bind):
    try:
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        sock.bind((bind, port))

    except Exception as err:
        print('*** Bind failed: {}'.format(err))
        sys.exit(1)

    threads = []
    while True:
        try:
            sock.listen(100) 
            client, addr = sock.accept()
        except Exception as err:
            print('*** Hata: {}'.format(err))
        new_thread = threading.Thread(target=handle_connection, args=(client, addr,sock))
        new_thread.start()
        threads.append(new_thread)

    for thread in threads:
        thread.join()


if __name__ == "__main__":
    start_server(22, "0.0.0.0")
    db.close()