% modbusObj = NET.addAssembly('C:\CellChip\Camilo\Modbus dlls\bin\net\Modbus.dll');
% modbusObj = NET.addAssembly('C:\CellChip\Camilo\Modbus dlls\Source\src\Modbus\bin\Debug\Modbus.dll');
%%
systemObj = NET.addAssembly('System');
%%
nmodbusObj = NET.addAssembly('C:\Matlab_FromUCSF\Matlab\Wago\Wago DLL\NModbus\Modbus.dll');

%%
% Create Tcp Client
% ipAddressClient = System.Net.IPAddress.Parse('192.168.1.1');
% ipEndPoint = System.Net.IPEndPoint(ipAddressClient, 502);
% echotcpip('on',5500);
% tcpClient = System.Net.Sockets.TcpClient(System.Net.Dns.GetHostName(), 5500);
% tcpClient = System.Net.Sockets.TcpClient(ipAddressClient, 502);
% tcpClient = System.Net.Sockets.TcpClient(ipEndPoint);
tcpClient = System.Net.Sockets.TcpClient('192.168.1.3', 502);


%%
% Create Modbus Tcp Master Connection
% master = Modbus.Device.ModbusMasterTcpConnection(tcpClient, tcpSlave);
% master = Modbus.Device.ModbusIpMaster.CreateTcp(tcpClient);
%%
master = Modbus.Device.ModbusIpMaster.CreateIp(tcpClient);

%%
master.WriteMultipleCoils(0,logical([1 0 0 1 0 1 0 0 1 1 1 0 1 0 0 1]));
% master.WriteMultipleCoils(0,logical([0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1]));
% master.WriteMultipleCoils(0,logical([1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0]));
% master.WriteMultipleCoils(0,logical([0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]));
% master.WriteMultipleCoils(0,logical([1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1]));
%%
for ii=0:31
    master.WriteSingleCoil(ii,logical(0));
    pause(0.1)
end
%%
startAddress = 512;
numberOfRegisters = 1;
values = master.ReadHoldingRegisters(startAddress,numberOfRegisters);
for ii=0:numberOfRegisters-1
    readValue(ii+1) = values.GetValue(ii);
end
dec2bin(readValue(1))
% %%
% % Delete object
% ipEndPoint.delete;
% clear ipEndPoint
% %%
% ipAddressClient.delete;
% clear ipAddressClient

%%
% Create Modbus Tcp Slave
% Modbus.Device.ModbusTcpSlave(unitId, tcpListener)

% Create tcp Listener
ipAddress = System.Net.IPAddress.Parse('192.168.1.3');
tcpListener = System.Net.Sockets.TcpListener(ipAddress, 502);

tcpSlave = Modbus.Device.ModbusTcpSlave.CreateTcp(2, tcpListener);
