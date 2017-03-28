unit RequestQueue;
	interface
	const
		NULLQ=NIL;
	type
		tCode=char;
		tItemQ= record
			code:tCode;
			parameter1:string;
			parameter2:string;
			parameter3:string;
			parameter4:string;
		end;
		tPosQ=^tNodeQ;
		tQueue=record
			ini:tPosQ;
			fin:tPosQ;
		end;
		
		tNodeQ= record
			item:tItemQ;
			next:tPosQ;
		end;
		
	
	
	function createEmptyQueue:tQueue;
	function isEmptyQueue(Queue:tQueue):Boolean;
	function enqueue(var Queue:tQueue; i:tItemQ):Boolean;
	function front(Queue:tQueue):tItemQ;
	procedure dequeue(VAR Queue:tQueue);
	
	implementation
	
	function createEmptyQueue:tQueue;
	begin
		createEmptyQueue.ini:=NULLQ;
		createEmptyQueue.fin:=NULLQ;
	end;
	
	function isEmptyQueue(Queue:tQueue):Boolean;
	begin
		 isEmptyQueue:=((Queue.ini=NULLQ)AND(Queue.fin=NULLQ));
	end;
	
	procedure createNode(i:tItemQ; VAR newNode:tPosQ);
	begin
		newNode:=NULLQ;
		new(newNode);
		if newNode<>NULLQ then begin
			newNode^.item:=i;
			newNode^.next:=NULLQ;
		end;
	end;
	
	function enqueue(var Queue:tQueue; i:tItemQ):boolean;
	var newNode:tPosQ;
	begin
		createNode(i,newNode);
		if newNode <> NULLQ then begin
			if isEmptyQueue(Queue) then
				Queue.ini:=newNode
			else
				Queue.fin^.next:=newNode;
		Queue.fin:= newNode;
		enqueue:=TRUE;
		end else
		enqueue:=FALSE;
	end;

	function front(Queue:tQueue):tItemQ;
	begin
		front:=Queue.ini^.item;
	end;
	
	procedure dequeue(VAR Queue:tQueue);
	var p:tPosQ;
	begin
		p:=Queue.ini;
		Queue.ini:=p^.next;
		if Queue.ini=NULLQ then
			Queue.fin:=NULLQ;
		dispose(p);
	end;

end.
