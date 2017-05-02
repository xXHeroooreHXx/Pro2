{
TITLE: PROGRAMMING II LABS  
SUBTITLE: Practical 2
AUTHOR 1: Julián Penedo Carrodeguas LOGIN 1: j.pcarrodeguas
AUTHOR 2: Pablo Ramos Muras LOGIN 2: pablo.muras 
GROUP: 4.2  
DATE: 28/03/2017
}

unit DessertList;
	interface
	uses IngredientList,sysutils;

	const
		MAX=100;
		NULLD=0;
			
	type
		tnDessert=string;
		tPrice=real;
		tItemD= record
			nDessert:tnDessert;
			price:tPrice;
			recipe:tListI;
		end;
		tPosD= NULLD..MAX;
		tListD= record 
			data:array [1..MAX] of tItemD;
			endList: tPosD;
		end;
		
	procedure createEmptyListD(VAR L:tListD);
	function isEmptyListD(L:tListD):boolean;
	function firstD(L:tListD):tPosD;
	function lastD(L:tListD):tPosD;
	function nextD(p:tPosD; L:tListD):tPosD;
	function previousD(p:tPosD; L:tListD):tPosD;
	function insertItemD(i:tItemD; var L:tListD):boolean;
	procedure deleteAtPositionD (p:tPosD; VAR L:tListD);
	function getItemD (p:tPosD; L:tListD):tItemD;
	procedure updateItemD (VAR L:tListD; p:tPosD; i:tItemD);
	function findItemD (name:tnDessert; L:tListD):tPosD;
	
	implementation
	
	procedure createEmptyListD(VAR L:tListD);
	(*Crea una lista vacía.
	PostCD: La lista queda inicializada y no contiene elementos.*)
	begin
		L.endList:=NULLD;
	end;
	
	function isEmptyListD(L:tListD):boolean;
	(*Determina si la lista está vacía.*)
	begin
		isEmptyListD:=(L.endList=NULLD);
	end;
	
	function firstD(L:tListD):tPosD;
	(*Devuelve la posición del primer elemento de la lista.
	PreCD: La lista no está vacía.*)
	begin
		firstD:=1;
	end;
	
	function lastD(L:tListD):tPosD;
	(*Devuelve la posición del último elemento de la lista.
	PreCD: La lista no está vacía.*)
	begin
		lastD:=L.endlist;
	end;
	
	function nextD(p:tPosD; L:tListD):tPosD;
	(*Devuelve la posición en la lista del elemento siguiente al de la posición indicada (o NULLD si la posición no tiene siguiente).
	PreCD: La posición indicada es una posición válida en la lista.*)
	begin
		if p=l.endlist then
			nextD:=NULLD
		else 
			nextD:=p+1;
	end;
	
	function previousD(p:tPosD; L:tListD):tPosD;
	(*Devuelve la posición en la lista del elemento anterior al de la posición indicada (o NULLD si la posición no tiene anterior).
	PreCD: La posición indicada es una posición válida en la lista.*)
	begin
		if p=firstD(L) then
			previousD:=NULLD
		else 
			previousD:=p-1;
	end;
	
	function insertItemD(i:tItemD; var L:tListD):boolean;
	(*Inserta un elemento con los datos indicados en la lista, en la posición que le corresponde según la ordenación utilizada.
	Si el elemento en cuestión pudo ser insertado, se devuelve un valor true; sino se devuelve false.
	PreCD: La posición indicada es una posición válida en la lista o bien una posición nula (NULLD).
	PostCD: Las posiciones de los elementos de la lista a continuación del insertado dejan de ser válidas.*)
	var
		q,p:tPosD;	
	begin
		if L.endlist = MAX then
			insertItemD:=false
		else begin
			if(isEmptyListD(L)) then begin
				insertItemD:=true;
				L.endList:=L.endList+1;
				L.data[1] := i;
			end
			else begin
				p:=firstD(l);
				while ((p<>NULLD)AND(CompareText(i.nDessert,L.data[p].nDessert)>0)) do
						p:=nextD(p,l);
				
				insertItemD:=true;
				L.endList:=L.endList+1;
				if p = NULLD then
					L.data[L.endList]:=i
				else begin
					for q:=L.endList downto p+1 do
						L.data[q]:=L.data[q-1];
					L.data[p]:=i;
				end;
			end;
		end;
	end;

	
	procedure deleteAtPositionD (p:tPosD; VAR L:tListD);
	(*Elimina de la lista el elemento que ocupa la posición indicada.
	PreCD: La posición indicada es una posición válida en la lista.
	PostCD: Tanto la posición del elemento eliminado como aquéllas de los elementos de la lista a continuación del mismo dejan de ser válidas.*)
	var
	q:tPosD;
	begin
		for q:=p to (L.endList -1) do
			L.data[q]:=L.data[q+1];
		L.endList:=L.endList-1;
	end;
	
	function getItemD (p:tPosD; L:tListD):tItemD;
	(*Devuelve el contenido del elemento de la lista que ocupa la posición indicada.
	PreCD: La posición indicada es una posición válida en la lista.*)
	begin
		getItemD:=L.data[p];
	end;
	
	procedure updateItemD(VAR L:tListD; p:tPosD; i:tItemD);
	(*Modifica el contenido del elemento situado en la posición indicada.
	PreCD: La posición indicada es una posición válida en la lista.
	PostCD: El orden de los elementos de la lista no se ve modificado.*)
	begin
		L.data[p]:=i;		
	end;
	
	function findItemD (name:tnDessert; L:tListD):tPosD;
	(*Devuelve la posición del primer elemento de la lista cuyo nombre de ingrediente se corresponda con el indicado (o NULLD si no existe tal elemento).
	Deja de buscar si todavia no ha encontrado un elemento pero encuentra un elemento con una posición posterior al buscado*)
	var
		p:tPosD;
	begin
		findItemD:=NULLD;
		p:=firstD(L);
		while ((p <> NULLD)AND(CompareText(name,L.data[p].nDessert)>=0))  do
		begin
			if (L.data[p].nDessert=name) then
				findItemD:=p;
			p:=nextD(p,L);
		end;
	end;
end.
