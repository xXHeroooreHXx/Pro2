program Practica2;

uses RequestQueue,crt,sysutils;

function SaveParameter(line:String;var i:integer):String;
var

	parameter:string[20]='';
	j:integer = 1;
	check:boolean = true;

begin
	while ((check = true) AND (i<=length(line)) AND (line[i]<>'#')) do begin
		
		 if (line[i]<>' ')
		 then begin
			Insert(line[i],parameter,j);
			j:=j+1;
		 end; 
		 if ((line[i+1]=' ')AND(parameter<>''))
		 then
			check:=false;
		
		i:=i+1;

end;
	SaveParameter:=trim(parameter);
end; 


var 
	q:tQueue;
    d: tItemQ;
    taskFile:string = 'New.txt';
    fileId : Text;
    line:string;
    i:integer = 2;

begin
	
	createEmptyQueue(q);
	
	{$i-}
		assign(fileId, taskFile);
		reset(fileId);
	{$i+}
	if (IOResult<>0) then begin
		writeln('**** Reading. Error when trying to open ', taskFile);
		halt(1);
	end;

  While (not EOF(fileId)) do
    begin
        readln(fileId, line);
        d.code := line[1];
        d.parameter1:=SaveParameter(line,i);
        d.parameter2:=SaveParameter(line,i);
        d.parameter3:=SaveParameter(line,i);
        d.parameter4:=SaveParameter(line,i);
        enqueue(q,d);
        i:=2;
    end;



end.
