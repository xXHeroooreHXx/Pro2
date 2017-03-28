program TestUnit;

//uses list;
//uses StaticList;
uses DynamicList,crt,sysutils;

procedure print_and_dequeue(Q : tQueue);

begin
   write('(');
   if not isEmptyQueue(Q) then
   begin
      while not isEmptyQueue(Q) do
      begin
		write(' ',front(Q).code,' ',front(Q).parameter1,' ',front(Q).parameter2,' ',front(Q).parameter3,' ',front(Q).parameter4);
		dequeue(Q);
      end;
   end;
   writeln(')');

end; 


var 
	q:tQueue;
    d,d1: tItemQ;
    taskFile:string = "New.txt";
    line:string;
    i:integer=2;
    j:integer=1;
    k:integer=1;
    splitter: array [1..5] of string;

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

	While (not EOF(fileId))  do
	begin
		readln(fileId, line);
		d.code:=line[1];
		while((i<length(line))AND(line[i]<>'#')) do begin
			if(line[i]<>' ') then begin
				splitter[j][k]:=line[i];
				k:=k+1;
			end
			else if(k<>0) then
				j:=j+1;
			i:=i+1;
		end;
		d.parameter1 := splitter[1];
		d.parameter2 := splitter[2];
		d.parameter3 := splitter[3];
		d.parameter4 := splitter[4];
		enqueue(d,q);
		
	end;
	print_and_dequeue(q);


end.
