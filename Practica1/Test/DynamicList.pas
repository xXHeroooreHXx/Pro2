unit DynamicList;
////////////////////////////////////////////////////////////////////////
							interface
////////////////////////////////////////////////////////////////////////							
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
	function insertItem(i:tItem; p:tPosL; var L:tList):boolean;
	procedure deleteAtPosition (p:tPosL; VAR L:tList);
	function getItem (p:tPosL; L:tList):tItem;
	procedure updateItem (L:tList; p:tPosL; i:tItem);
	function findItem (ing:tnIngredient; L:tList):tPosL;


////////////////////////////////////////////////////////////////////////
							implementation	
////////////////////////////////////////////////////////////////////////
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

	procedure createNode(d:tItem;VAR newPos:tPosL);
	begin
		newPos:=NULL;
		new(newPos);
		if newPos <> NULL then
		begin
			newPos^.item:=d;
			newPos^.next:=NULL;
		end;
	end;

	function insertItem(i:tItem; p:tPosL; var L:tList):boolean;
	var
		newPos,q:tPosL;
	
	begin
		createNode(i,newPos);
		if (newPos=NULL) then
			insertItem:=false
		else
		begin
			insertItem:=true;
			if L=NULL then
				L:=newPos
			else if p = NULL then
			begin
				q:=L;
				while (q^.next <> NULL) do
					q:=q^.next;
				q^.next:=newPos;
			end
			else
			begin
				newPos^.item:=p^.item;
				p^.item:=i;
				newPos^.next:=p^.next;
				p^.next:=newPos;
			end;
		end;
	end;

	procedure deleteAtPosition (p:tPosL; VAR L:tList);
	var
		q:tPosL;

	begin
		if p=L then
			L:=L^.next
		else begin
			q:=previous(p,L);
			q^.next := p^.next;
		end;
		dispose(p);
	end;

	function getItem(p:tPosL; L:tList): tItem;
	begin
		getItem:=p^.item;
	end;

	procedure updateItem(L:tList;p:tPosL;i:tItem);
	begin
		p^.item:=i;
	end;

	function findItem (ing:tnIngredient; L:tList):tPosL;
	var
		p:tPosL;
	begin
		p:=L;
		findItem:=NULL;
		if(p = NULL) then begin
			findItem := p;
			writeln('NULL');
			end
		else begin
			if(l^.item.nIngredient = ing) then begin
				findItem := p;
				writeln('Encontrado');
				end
			else begin
				writeln('Siguiente');
				findItem:=findItem(ing,next(p,l));
			end;
		end;
	end;
end.
