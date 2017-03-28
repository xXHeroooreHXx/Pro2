{
TITLE: PROGRAMMING II LABS  
SUBTITLE: Practical 1
AUTHOR 1: Julián Penedo Carrodeguas LOGIN 1: j.pcarrodeguas
AUTHOR 2: Pablo Ramos Muras LOGIN 2: pablo.muras 
GROUP: 4.2  
DATE: 14/03/2017
}

unit DessertList;
	interface
	uses IngredientList;

	const
		MAX=100;
		NULL=0;
			
	type
		tnDessert=string;
		tPrice=real;
		tItemD= record
			nDessert:tnDessert;
			price:tPrice;
			recipe:tListI;
		end;
		tPosD= NULL..MAX;
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
	function insertItemDD(i:tItemD; p:tPosD; var L:tListD):boolean;
	procedure deleteAtPositionD (p:tPosD; VAR L:tListD);
	function getItemDD (p:tPosD; L:tListD):tItemD;
	procedure updateItem (VAR L:tListD; p:tPosD; i:tItemD);
	function findItemD (name:tnDessert; L:tListD):tPosD;
	
	implementation
	
	procedure createEmptyListD(VAR L:tListD);
	(*Crea una lista vacía.
	PostCD: La lista queda inicializada y no contiene elementos.*)
	begin
		L.endList:=NULL;
	end;
	
	function isEmptyListD(L:tListD):boolean;
	(*Determina si la lista está vacía.*)
	begin
		isEmptyListD:=(L.endList=NULL);
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
	(*Devuelve la posición en la lista del elemento siguiente al de la posición indicada (o NULL si la posición no tiene siguiente).
	PreCD: La posición indicada es una posición válida en la lista.*)
	begin
		if p=l.endlist then
			nextD:=NULL
		else 
			nextD:=p+1;
	end;
	
	function previousD(p:tPosD; L:tListD):tPosD;
	(*Devuelve la posición en la lista del elemento anterior al de la posición indicada (o NULL si la posición no tiene anterior).
	PreCD: La posición indicada es una posición válida en la lista.*)
	begin
		if p=firstD(L) then
			previousD:=NULL
		else 
			previousD:=p-1;
	end;
	
	function insertItemDD(i:tItemD; p:tPosD; var L:tListD):boolean;
	(*Inserta un elemento con los datos indicados en la lista, inmediatamente antes de la posición indicada. 
	Si dicha posición indicada es NULL, entonces el elemento se añade al final.
	Si el elemento en cuestión pudo ser insertado, se devuelve un valor true; sino se devuelve false.
	PreCD: La posición indicada es una posición válida en la lista o bien una posición nula (NULL).
	PostCD: Las posiciones de los elementos de la lista a continuación del insertado dejan de ser válidas.*)
	var
		q:tPosD;	
	begin
		if L.endlist = MAX then
			insertItemDD:=false
		else
			begin
				insertItemDD:=true;
				L.endList:=L.endList+1;
				if p = NULL then
					L.data[L.endList]:=i
				else begin
					for q:=L.endList downto p+1 do
						L.data[q]:=L.data[q-1];
						
					L.data[p]:=i;
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
	
	function getItemDD (p:tPosD; L:tListD):tItemD;
	(*Devuelve el contenido del elemento de la lista que ocupa la posición indicada.
	PreCD: La posición indicada es una posición válida en la lista.*)
	begin
		getItemDD:=L.data[p];
	end;
	
	procedure updateItem (VAR L:tListD; p:tPosD; i:tItemD);
	(*Modifica el contenido del elemento situado en la posición indicada.
	PreCD: La posición indicada es una posición válida en la lista.
	PostCD: El orden de los elementos de la lista no se ve modificado.*)
	begin
		L.data[p]:=i;		
	end;
	
	function findItemD (name:tnDessert; L:tListD):tPosD;
	(*Devuelve la posición del primer elemento de la lista cuyo nombre de ingrediente se corresponda con el indicado (o NULL si no existe tal elemento).*)
	var
		p:tPosD;
	begin
		findItemD:=NULL;
		p:=firstD(L);
		while ((findItemD=NULL) AND (p <> NULL)) do
		begin
			if (L.data[p].nDessert=name) then
				findItemD:=p;
			p:=nextD(p,L);
		end;
	end;
end.
