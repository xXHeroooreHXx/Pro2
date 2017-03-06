unit DinamicList;
	interface
	const
		NULL = NIL;

	type
		tnIngredient=string;
		tQuantity=integer;
		tGluten=boolean;
		tMilk=boolean;	
		tAllergens= record
			gluten:tGluten;
			milk:tMilk;
			end;

		tItem= record
			nIngredient:tnIngredient;
			quantity:tQuantity;
			allergens:tAllergens;
			end;
	
		tPosL= ^tNode;

	
		tNode = record
			item:tItem;
			next:tPosL;
		end;
		tList = tPosL;
	
	procedure createEmptyList(VAR L:tList);
	function isEmptyList(L:tList):boolean;
	function first(L:tList):tPosL;
	function last(L:tList):tPosL;
	function next(p:tPosL; L:tList):tPosL;
	function previous(p:tPosL; L:tList):tPosL;
	procedure createNode(d:tData;VAR newPos:tPosL);
	function insertItem(i:tItem; p:tPosL; L:tList):boolean;
	procedure deleteAtPosition (p:tPosL; VAR L:tList);
	function getItem (p:tPosL; L:tList):tItem;
	procedure updateItem (VAR L:tList; p:tPosL; i:tItem);
	function findItem (ing:tnIngredient; L:tList):tPosL;



	implementation	

	procedure createEmptyList(var L:tList);
	begin
		L:=NULL;
	end;

	function isEmptyList(L:tList):boolean;
	begin
		isEmptyList:=(L=NULL)
	end;

	function first(L:tList):tPosL;
	begin
		first:=L;
	end;

	function last(L:tList):tPosL;
	var
		p:tPosL;
	begin
		p:=first(L);
		while(p^.next <> NULL) do
			p:=p^.next;
		last:=p;
	end;

	function next(p:tPosL; L:tList):tPosL;
	begin
		next:=p^.next;
	end;

	function previous(p:tPosL; L:tList):tPosL;
	var
		q:tPosL;
	begin
		if(p=l) then
			previous:=NULL
		else begin
			q:=first(L);
			while(q^.next <> p) do
				q:=q^.next;
			previous := q;
		end;
	end;

	procedure createNode(d:tData;VAR newPos:tPosL);
	begin
		newPos:=NULL;
		new(newPos);
		if newPos <> NULL then
		begin
			newPos.data:=d;
			newPos.next:=NULL;
		end;
	end;

	function insertItem(i:tItem; p:tPosL; L:tList):boolean;
	var
		newPos,q:tPosL;
	
	begin
		createNode(d,newNode);
		if (newNode=NULL) then
			insertItem:=false;
		else
		begin
			insertItem:=true;
			if L=NULL then
				L:=newPos;
			else if p = NULL then
			begin
				q:=L;
				while (q^.next <> NULL) do
					q:=q^.next;
				q^.next:=newPos;
			end
			else
			begin
				newPos^.item:p^.item;
				p^.item:=d;
				newPos^.next:p^.next;
				p^.next:=newPos;
			end;
		end;
	end;

	procedure deleteAtPosition (p:tPosL; VAR L:tList);
	var
		q:tPosL;

	begin
		if p=L then
			L:=L^.next;
		else if p^.next=NULL then
		begin
			q:=L;
			while q^.next <> p
				q:=q^.next;
			q^.next:=NULL;
		end;
		else
		begin
			q:=p^.next;
			p^.item:=q^.item;
			p^.next:=q^.next;
			p:=q;
		end;
		dispose(p);
	end;

	function getItem(p:tPosL; L:tList): tItem;
	begin
	getItem:=p^.item;
	end;

	procedure updateItem(var L:tList;p:tPosL;i:tItem);
	begin
		p^.item:=i;
	end;

	function findItem (ing:tnIngredient; L:tList):tPosL;
	begin
		if(L^.item.nIngredient = ing) then
			findItem := l
		else
			findItem(ing,L^.next);
	end;
end.
