{
TITLE: PROGRAMMING II LABS  
SUBTITLE: Practical 1
AUTHOR 1: Julián Penedo Carrodeguas LOGIN 1: j.pcarrodeguas
AUTHOR 2: Pablo Ramos Muras LOGIN 2: pablo.muras 
GROUP: 4.2  
DATE: 14/03/2017
}

unit DynamicList;
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
	function insertItem(i:tItem; p:tPosL; var L:tList):boolean;
	procedure deleteAtPosition (p:tPosL; VAR L:tList);
	function getItem (p:tPosL; L:tList):tItem;
	procedure updateItem (L:tList; p:tPosL; i:tItem);
	function findItem (ing:tnIngredient; L:tList):tPosL;



	implementation	

	procedure createEmptyList(var L:tList);
	(*Crea una lista vacía.
	PostCD: La lista queda inicializada y no contiene elementos.*)
	begin
		L:=NULL;
	end;

	function isEmptyList(L:tList):boolean;
	(*Determina si la lista está vacía.*)
	begin
		isEmptyList:=(L=NULL)
	end;

	function first(L:tList):tPosL;
	(*Devuelve la posición del primer elemento de la lista.
	PreCD: La lista no está vacía.*)
	begin
		first:=L;
	end;

	function last(L:tList):tPosL;
	(*Devuelve la posición del último elemento de la lista.
	PreCD: La lista no está vacía.*)
	var
		p:tPosL;
	begin
		p:=first(L);
		while(p^.next <> NULL) do
			p:=p^.next;
		last:=p;
	end;

	function next(p:tPosL; L:tList):tPosL;
	(*Devuelve la posición en la lista del elemento siguiente al de la posición indicada (o NULL si la posición no tiene siguiente).
	PreCD: La posición indicada es una posición válida en la lista.*)	
	begin
		next:=p^.next;
	end;

	function previous(p:tPosL; L:tList):tPosL;
	(*Devuelve la posición en la lista del elemento anterior al de la posición indicada (o NULL si la posición no tiene anterior).
	PreCD: La posición indicada es una posición válida en la lista.*)
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
	(*Inserta un elemento con los datos indicados en la lista, inmediatamente antes de la posición indicada. 
	Si dicha posición indicada es NULL, entonces el elemento se añade al final.
	Si el elemento en cuestión pudo ser insertado, se devuelve un valor true; sino se devuelve false.
	PreCD: La posición indicada es una posición válida en la lista o bien una posición nula (NULL).
	PostCD: Las posiciones de los elementos de la lista a continuación del insertado dejan de ser válidas.*)
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
	(*Inserta un elemento con los datos indicados en la lista, inmediatamente antes de la posición indicada. 
	Si dicha posición indicada es NULL, entonces el elemento se añade al final.
	Si el elemento en cuestión pudo ser insertado, se devuelve un valor true; sino se devuelve false.
	PreCD: La posición indicada es una posición válida en la lista o bien una posición nula (NULL).
	PostCD: Las posiciones de los elementos de la lista a continuación del insertado dejan de ser válidas.*)
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
	(*Devuelve el contenido del elemento de la lista que ocupa la posición indicada.
	PreCD: La posición indicada es una posición válida en la lista.*)
	begin
		getItem:=p^.item;
	end;

	procedure updateItem(L:tList;p:tPosL;i:tItem);
	(*Modifica el contenido del elemento situado en la posición indicada.
	PreCD: La posición indicada es una posición válida en la lista.
	PostCD: El orden de los elementos de la lista no se ve modificado.*)begin
		p^.item:=i;
	end;

	function findItem (ing:tnIngredient; L:tList):tPosL;
	(*Devuelve la posición del primer elemento de la lista cuyo nombre de ingrediente se corresponda con el indicado (o NULL si no existe tal elemento).*)
	var
		p:tPosL;
	begin
		p:=first(L);
		findItem:=NULL;
		while((p<>NULL)AND(findItem=NULL)AND(p^.item.nIngredient <> ing)) do
			p:=p^.next;
		findItem:=p;	
	end;	
end.
