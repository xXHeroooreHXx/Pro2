{
TITLE: PROGRAMMING II LABS  
SUBTITLE: Practical 2
AUTHOR 1: Julián Penedo Carrodeguas LOGIN 1: j.pcarrodeguas
AUTHOR 2: Pablo Ramos Muras LOGIN 2: pablo.muras 
GROUP: 4.2  
DATE: 02/05/2017
}

unit IngredientList;
	interface
	const
		NULLI = NIL;

	type
		tnIngredient=string;
		tQuantity=integer;
		tGluten=boolean;
		tMilk=boolean;	
		tAllergens= record
			gluten:tGluten;
			milk:tMilk;
			end;

		tItemI= record
			nIngredient:tnIngredient;
			quantity:tQuantity;
			allergens:tAllergens;
			end;
	
		tPosI= ^tNode;

	
		tNode = record
			item:tItemI;
			nextI:tPosI;
		end;
		tListI = tPosI;
	
	procedure createEmptyListI(VAR L:tListI);
	function isEmptyListI(L:tListI):boolean;
	function firstI(L:tListI):tPosI;
	function lastI(L:tListI):tPosI;
	function nextI(p:tPosI; L:tListI):tPosI;
	function previousI(p:tPosI; L:tListI):tPosI;
	function insertItemI(i:tItemI; p:tPosI; var L:tListI):boolean;
	procedure deleteAtPositionI (p:tPosI; VAR L:tListI);
	function getItemI (p:tPosI; L:tListI):tItemI;
	procedure updateItemI (var L:tListI; var p:tPosI; i:tItemI);
	function findItemI (ing:tnIngredient; L:tListI):tPosI;



	implementation	

	procedure createEmptyListI(var L:tListI);
	(*Crea una lista vacía.
	PostCD: La lista queda inicializada y no contiene elementos.*)
	begin
		L:=NULLI;
	end;

	function isEmptyListI(L:tListI):boolean;
	(*Determina si la lista está vacía.*)
	begin
		isEmptyListI:=(L=NULLI)
	end;

	function firstI(L:tListI):tPosI;
	(*Devuelve la posición del primer elemento de la lista.
	PreCD: La lista no está vacía.*)
	begin
		firstI:=L;
	end;

	function lastI(L:tListI):tPosI;
	(*Devuelve la posición del último elemento de la lista.
	PreCD: La lista no está vacía.*)
	var
		p:tPosI;//posicion en la lista
	begin
		p:=firstI(L);
		while(p^.nextI <> NULLI) do
			p:=p^.nextI;
		lastI:=p;
	end;

	function nextI(p:tPosI; L:tListI):tPosI;
	(*Devuelve la posición en la lista del elemento siguiente al de la posición indicada (o NULLI si la posición no tiene siguiente).
	PreCD: La posición indicada es una posición válida en la lista.*)	
	begin
		nextI:=p^.nextI;
	end;

	function previousI(p:tPosI; L:tListI):tPosI;
	(*Devuelve la posición en la lista del elemento anterior al de la posición indicada (o NULLI si la posición no tiene anterior).
	PreCD: La posición indicada es una posición válida en la lista.*)
	var
		q:tPosI; //posicion en la lista
	begin
		if(p=l) then
			previousI:=NULLI
		else begin
			q:=firstI(L);
			while(q^.nextI <> p) do
				q:=q^.nextI;
			previousI := q;
		end;
	end;

	procedure createNode(d:tItemI;VAR newPos:tPosI);
	begin
		newPos:=NULLI;
		new(newPos);
		if newPos <> NULLI then
		begin
			newPos^.item:=d;
			newPos^.nextI:=NULLI;
		end;
	end;

	function insertItemI(i:tItemI; p:tPosI; var L:tListI):boolean;
	(*Inserta un elemento con los datos indicados en la lista, ordenado segun el nombre del ingrediente
	PreCD: La posición indicada es una posición válida en la lista o bien una posición nula (NULLI).
	PostCD: Las posiciones de los elementos de la lista a continuación del insertado dejan de ser válidas.*)
	var
		newPos,q:tPosI; //dos posiciones distintas en la lista
	
	begin
		createNode(i,newPos);
		if (newPos=NULLI) then
			insertItemI:=false
		else
		begin
			insertItemI:=true;
			if L=NULLI then
				L:=newPos
			else if p = NULLI then
			begin
				q:=L;
				while (q^.nextI <> NULLI) do
					q:=q^.nextI;
				q^.nextI:=newPos;
			end
			else
			begin
				newPos^.item:=p^.item;
				p^.item:=i;
				newPos^.nextI:=p^.nextI;
				p^.nextI:=newPos;
			end;
		end;
	end;

	procedure deleteAtPositionI (p:tPosI; VAR L:tListI);
	(*Inserta un elemento con los datos indicados en la lista, inmediatamente antes de la posición indicada. 
	Si dicha posición indicada es NULLI, entonces el elemento se añade al final.
	Si el elemento en cuestión pudo ser insertado, se devuelve un valor true; sino se devuelve false.
	PreCD: La posición indicada es una posición válida en la lista o bien una posición nula (NULLI).
	PostCD: Las posiciones de los elementos de la lista a continuación del insertado dejan de ser válidas.*)
	var
		q:tPosI;//Posicion en la lista

	begin
		if p=L then
			L:=L^.nextI
		else begin
			q:=previousI(p,L);
			q^.nextI := p^.nextI;
		end;
		dispose(p);
	end;

	function getItemI(p:tPosI; L:tListI): tItemI;
	(*Devuelve el contenido del elemento de la lista que ocupa la posición indicada.
	PreCD: La posición indicada es una posición válida en la lista.*)
	begin
		getItemI:=p^.item;
	end;

	procedure updateItemI(var L:tListI;var p:tPosI;i:tItemI);
	(*Modifica el contenido del elemento situado en la posición indicada.
	PreCD: La posición indicada es una posición válida en la lista.
	PostCD: El orden de los elementos de la lista no se ve modificado.*)
	begin
		p^.item:=i;
	end;

	function findItemI (ing:tnIngredient; L:tListI):tPosI;
	(*Devuelve la posición del primer elemento de la lista cuyo nombre de ingrediente se corresponda con el indicado (o NULLI si no existe tal elemento).*)
	var
		p:tPosI; //posicion en la lista
	begin
		p:=firstI(L);
		findItemI:=NULLI;
		while((p<>NULLI)AND(findItemI=NULLI)AND(p^.item.nIngredient <> ing)) do
			p:=p^.nextI;
		findItemI:=p;	
	end;	
end.
