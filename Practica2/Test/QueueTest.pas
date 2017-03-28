program TestUnit;

//uses list;
//uses StaticList;
uses RequestQueue,crt,sysutils;

procedure print_and_dequeue(Q : tQueue);

begin
   write('(');
   if not isEmptyQueue(Q) then
   begin
      while not isEmptyQueue(Q) do
      begin
		writeln(' ',front(Q).code,' ',front(Q).parameter1,' ',front(Q).parameter2,' ',front(Q).parameter3,' ',front(Q).parameter4);
		dequeue(Q);
      end;
   end;
   writeln(')');

end;

function SaveParameter(line:String;var i:integer):String;
var
parameter:string[20]='';
j:integer = 1;
check:boolean = true;
begin
	while ((check = true) AND (i<=length(line)) AND (line[i]<>'#' )) do begin
		
		 if (line[i]<>' ') AND (parameter='')
		 then begin
			Insert(line[i],parameter,j);
			j:=j+1;
		 end; 
		 if ((line[i+1]=' ')AND(line[i+2]=' ')AND(parameter<>''))
		 then
			check:=false;
		
		i:=i+1;

end;

	SaveParameter:=parameter;
end; 


var 
	q:tQueue;
    d: tItemQ;
    taskFile:string = 'New.txt';
    fileId : Text;
    line:string;
    i:integer = 2;

begin
	
	q:=createEmptyQueue;
	
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
	print_and_dequeue(q);



end.
