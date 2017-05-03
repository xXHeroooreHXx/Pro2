{
TITLE: PROGRAMMING II LABS  
SUBTITLE: Practical 1
AUTHOR 1: Julián Penedo Carrodeguas LOGIN 1: j.pcarrodeguas
AUTHOR 2: Pablo Ramos Muras LOGIN 2: pablo.muras 
GROUP: 4.2  
DATE: 14/03/2017
}

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
	function insertItem(i:tItem; p:tPosL; var L:tList):boolean;
	procedure deleteAtPosition (p:tPosL; VAR L:tList);
	function getItem (p:tPosL; L:tList):tItem;
	procedure updateItem (VAR L:tList; p:tPosL; i:tItem);
	function findItem (ing:tnIngredient; L:tList):tPosL;
	
	implementation
	
	procedure createEmptyList(VAR L:tList);
	(*Crea una lista vacía.
	PostCD: La lista queda inicializada y no contiene elementos.*)
	begin
		L.endList:=NULL;
	end;
	
	function isEmptyList(L:tList):boolean;
	(*Determina si la lista está vacía.*)
	begin
		isEmptyList:=(L.endList=NULL);
	end;
	
	function first(L:tList):tPosL;
	(*Devuelve la posición del primer elemento de la lista.
	PreCD: La lista no está vacía.*)
	begin
		first:=1;
	end;
	
	function last(L:tList):tPosL;
	(*Devuelve la posición del último elemento de la lista.
	PreCD: La lista no está vacía.*)
	begin
		last:=L.endlist;
	end;
	
	function next(p:tPosL; L:tList):tPosL;
	(*Devuelve la posición en la lista del elemento siguiente al de la posición indicada (o NULL si la posición no tiene siguiente).
	PreCD: La posición indicada es una posición válida en la lista.*)
	begin
		if p=l.endlist then
			next:=NULL
		else 
			next:=p+1;
	end;
	
	function previous(p:tPosL; L:tList):tPosL;
	(*Devuelve la posición en la lista del elemento anterior al de la posición indicada (o NULL si la posición no tiene anterior).
	PreCD: La posición indicada es una posición válida en la lista.*)
	begin
		if p=first(L) then
			previous:=NULL
		else 
			previous:=p-1;
	end;
	
	function insertItem(i:tItem; p:tPosL; var L:tList):boolean;
	(*Inserta un elemento con los datos indicados en la lista, inmediatamente antes de la posición indicada. 
	Si dicha posición indicada es NULL, entonces el elemento se añade al final.
	Si el elemento en cuestión pudo ser insertado, se devuelve un valor true; sino se devuelve false.
	PreCD: La posición indicada es una posición válida en la lista o bien una posición nula (NULL).
	PostCD: Las posiciones de los elementos de la lista a continuación del insertado dejan de ser válidas.*)
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
					L.data[L.endList]:=i
				else begin
					for q:=L.endList downto p+1 do
						L.data[q]:=L.data[q-1];
						
					L.data[p]:=i;
				end;
			end;
	end;
	
	procedure deleteAtPosition (p:tPosL; VAR L:tList);
	(*Elimina de la lista el elemento que ocupa la posición indicada.
	PreCD: La posición indicada es una posición válida en la lista.
	PostCD: Tanto la posición del elemento eliminado como aquéllas de los elementos de la lista a continuación del mismo dejan de ser válidas.*)
	var
	q:tPosL;
	begin
		for q:=p to (L.endList -1) do
			L.data[q]:=L.data[q+1];
		L.endList:=L.endList-1;
	end;
	
	function getItem (p:tPosL; L:tList):tItem;
	(*Devuelve el contenido del elemento de la lista que ocupa la posición indicada.
	PreCD: La posición indicada es una posición válida en la lista.*)
	begin
		getItem:=L.data[p];
	end;
	
	procedure updateItem (VAR L:tList; p:tPosL; i:tItem);
	(*Modifica el contenido del elemento situado en la posición indicada.
	PreCD: La posición indicada es una posición válida en la lista.
	PostCD: El orden de los elementos de la lista no se ve modificado.*)
	begin
		L.data[p]:=i;		
	end;
	
	function findItem (ing:tnIngredient; L:tList):tPosL;
	(*Devuelve la posición del primer elemento de la lista cuyo nombre de ingrediente se corresponda con el indicado (o NULL si no existe tal elemento).*)
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
