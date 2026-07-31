function [sendsoc,receivesoc]=initmajordomo
%function [sendsoc,receivesoc]=initmajordomo
%
% This function initializes two ports:
% sendsoc --> is the handler to the port that will have a queue
%             with the remote machines that are available to receive 
%             a task
% receivesoc --> is a handler to the port that will have a queue
%             with the remote machines that finished its process and
%             are waiting to return the ouput variables
%
% by Lucio Andrade
magic_port=5321;
sendsoc=tcpip_servsocket(magic_port);
receivesoc=tcpip_servsocket(magic_port+1);

