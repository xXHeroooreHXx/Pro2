unit StaticList;
	interface
	const
		MAX=100;
		NULL=0;
			
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
		tPosL= NULL..MAX;
		tList= record 
			data:array [1..MAX] of tItem;
			endList: tPosL;
			end;
		
	procedure createEmptyList(VAR L:tList);
	function isEmptyList(L:tList):boolean;
	function first(L:tList):tPosL;
	function last(L:tList):tPosL;
	function next(p:tPosL; L:tList):tPosL;
	function previous(p:tPosL; L:tList):tPosL;
	function insertItem(i:tItem; p:tPosL; L:tList):boolean;
	procedure deleteAtPosition (p:tPosL; VAR L:tList);
	function getItem (p:tPosL; L:tList):tItem;
	procedure updateItem (VAR L:tList; p:tPosL; i:tItem);
	function findItem (ing:tnIngredient; L:tList):tPosL;
	
	implementation
	
	procedure createEmptyList(VAR L:tList);
	begin
		L.endList:=NULL;
	end;
	
	function isEmptyList(L:tList):boolean;
	begin
		isEmptyList:=(L.endList=NULL);
	end;
	
	function first(L:tList):tPosL;
	begin
		first:=1;
	end;
	
	function last(L:tList):tPosL;
	begin
		last:=L.endlist;
	end;
	
	function next(p:tPosL; L:tList):tPosL;
	begin
		if p=last(L) then
			next:=NULL
		else 
			p:=p+1;
	end;
	
	function previous(p:tPosL; L:tList):tPosL;
	begin
		if p=first(L) then
			previous:=NULL
		else 
			p:=p-1;
	end;
	
	function insertItem(i:tItem; p:tPosL; L:tList):boolean;
	var
		q:tPosL;	
	begin
		if L.endlist = MAX then
			insertItem:=false
		else
			begin
				insertItem:=true;
				L.endList:=L.endList+1;
				if p = NULL then
					L.data[L.endList+1]:=i
				else
				begin
					for q:=L.endList downto p+1 do
						L.data[q]:=L.data[q-1];
					L.data[p]:=i;
				end;
			end;
	end;
	
	procedure deleteAtPosition (p:tPosL; VAR L:tList);
	var
	q:tPosL;
	begin
		for q:=p to (L.endList -1) do
			L.data[p]:=L.data[p+1];
		
		L.endList:=L.endList-1;
	end;
	
	function getItem (p:tPosL; L:tList):tItem;
	begin
		getItem:=L.data[p];
	end;
	
	procedure updateItem (VAR L:tList; p:tPosL; i:tItem);
	begin
		L.data[p]:=i;		
	end;
	
	function findItem (ing:tnIngredient; L:tList):tPosL;
	var
		p:tPosL;
	begin
		findItem:=NULL;
		p:=first(L);
		while ((findItem=NULL) AND (p <> NULL)) do
		begin
			if (L.data[p].nIngredient=ing) then
				findItem:=p;
			p:=next(p,L);
		end;
	end;
end.
