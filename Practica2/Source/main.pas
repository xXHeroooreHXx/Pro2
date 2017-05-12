{
TITLE: PROGRAMMING II LABS  
SUBTITLE: Practical 2
AUTHOR 1: Julián Penedo Carrodeguas LOGIN 1: j.pcarrodeguas
AUTHOR 2: Pablo Ramos Muras LOGIN 2: pablo.muras 
GROUP: 4.2  
DATE: 02/05/2017
}


program main;

uses IngredientList,DessertList,RequestQueue,crt,sysutils;

////////////////////////////////Funciones Internas//////////////////////	
	
	function IntToStr(int:integer):string;
	begin
		Str(int,IntToStr);  (*Transforma un integer directamente a String.*)
	end;
	
	function boolToString(bool:boolean):string;
	begin
		if(bool)
			then boolToString := 'true'
			else boolToString := 'false'; (*Transforma un boolean en un string*)
			
	end;
	
	procedure imprimirItem(item:tItemI);
	begin
		writeln('* Ingredient ',item.nIngredient,': ',item.quantity); (*Procedimiento que imprime un item determinado, usado en allergens y en stock*)
		if(item.allergens.gluten)
		then writeln('      Contains gluten');
		
		if(item.allergens.milk)
		then writeln('      Contains milk');
	end;
	
	function imprimirReceta(itemD:tItemD;stock:tListI):boolean;
	var
		recipe : tListI; //receta del itemD
		posI:tPosI; //posicion en la lista de ingredientes
		item:tItemI; //item de la lista de ingredientes
		stockQuantity:tQuantity; //cantidad de producto restante
	begin	
		writeln('**** Dessert',itemD.nDessert);
		recipe:=itemD.recipe;
		posI:=firstI(recipe);
		imprimirReceta:=false;
		while(posI<>NULLI) do begin  (*Procedimiento interno que imprime la receta de un item y comprueba si cualquiera de los ingredientes se queda sin stock *)
			item:=getItemI(posI,recipe);
			stockQuantity:=getItemI(findItemI(item.nIngredient,stock),stock).quantity;
			writeln('* Ingredient', item.nIngredient,' ',item.quantity,'(available: ',stockQuantity,')');
			if(stockQuantity - item.quantity)<0 then
				imprimirReceta:=true;
			posI:=nextI(posI,recipe);
		end;
		
	end;
	
	procedure imprimirLinea(linea1,linea2,linea3,linea4,linea5,linea6,linea7:string);
	begin
		writeln('**** ',linea1,' ',linea2,' ',linea3,' ',linea4,' ',linea5);
	end;
	
	procedure imprimirError(error1,error2,error3,error4,error5:string); (*Dos funciones encargadas de imprimir lineas con el formato correcto*)
	begin
		writeln('++++ ',error1,' ',error2,' ',error3,' ',error4,' ',error5);
	end;
	
	procedure imprimirPostre(postre:titemD);
	var p:tPosI; //posicion en la lista de ingredientes
		milk:tMilk; //alergeno 1
		gluten:tGluten; //alergeno2
		listaI:tListI; //lista de ingredientes, para poner la receta del itemD
	begin
		listaI:=postre.recipe;
		writeln(postre.nDessert,': ', postre.price:0:2,'.');
		p:=firstI(listaI);
		if p = NULLI
			then writeln('Recipe not included.')
		else begin
			milk:=false;										(*Procedimiento que imprime el itemD de un poste*)
			gluten:=false;
			write('Contains: ');
			while p <> NULLI do begin
				write(getItemI(p,listaI).nIngredient,' ');
				milk:= (milk OR getItemI(p,listaI).allergens.milk);
				gluten:= (gluten OR getItemI(p,listaI).allergens.gluten);
				p:=nextI(p,listaI)
				end;
			writeln;
			if NOT gluten
				then writeln('Gluten Free.');
			if NOT milk
				then writeln('Milk Free.');
			writeln;
		end;
	end;
	
	function ActualizarStockyMenu(var listaD:tListD; var stock:tListI):boolean;
	var
		posI:tPosI; //posicion en la lista de ingredientes
		posD:tPosD; //posicion en la lista de postres
		itemI:tItemI; //elemento de la lista de ingredientes, mas comodo para volcar los datos que se imprimen
		itemD:tItemD; //elemento de la lista de postres, mas comodo para volcar los datos que se imprimen
		printed:boolean; //variable booleana que evita que varios textos se impriman en mas de una iteracion del bucle
		recipe:tListI; //receta del ItemD en cuestion
	begin
		posI:=firstI(stock);
		ActualizarStockyMenu:=true;
		while (posI<>NULLI) do begin
			itemI:=getItemI(posI,stock);
			if(itemI.quantity = 0)then begin
				ActualizarStockyMenu:=false;
				writeln('**** Removing ingredient ',itemI.nIngredient,' from stock');
				posD:=firstD(listaD);
				printed:=true;
				while (posD<>NULLD)AND(NOT(isEmptyListD(listaD))) do begin
					ItemD:=getItemD(posD,listaD);
					recipe:=ItemD.recipe;
					if(findItemI(itemI.nIngredient,recipe)<>NULLI) then begin
						if(printed) then                                                      (*funcion que detecta si un elemento de la lista de ingredientes esta gastado y elimina el postre y el elemento*)
							writeln('**** Removing desserts that contains ',itemI.nIngredient);
						printed:=false;
						writeln('*Removing ',itemD.nDessert);
						deleteAtPositionD(posD,listaD);
						posD:=firstD(listaD);
					end
					else
						posD:=nextD(posD,listaD);
				end;
				if(printed=false)then
					writeln('**** No more desserts affected');
				deleteAtPositionI(posI,Stock);
				posI:=firstI(Stock);
			end 
			else
				posI:=nextI(posI,Stock)
		end;
	end;
	
	procedure DeleteList(var L:tListI; var D:tListD);

	begin
		while NOT isEmptyListI(L) do
			deleteAtPositionI(lastI(L),L);
		while NOT isEmptyListD(D) do 
			deleteAtPositionD(LastD(d),d);
	end;
	function GOM(gluten:tGluten;milk:tMilk):string;
	begin
		if(gluten) then
			GOM:='gluten'
		else 
			if(milk) then
				GOM:='milk'
			else 
				GOM:= 'allergens';
	end;
	
	function SaveParameter(line:String;var i:integer):String;
var

	parameter:string[20]='';
	j:integer = 1;
	check:boolean = true;

begin
	while ((check = true) AND (i<=length(line)) AND (line[i]<>'#')) do begin
		
		 if (line[i]<>' ')
		 then begin
			Insert(line[i],parameter,j);
			j:=j+1;
		 end; 
		 if ((line[i+1]=' ')AND(parameter<>''))
		 then
			check:=false;
		
		i:=i+1;

end;
	SaveParameter:=trim(parameter);
end; 
////////////////////////////////////////////////////////////////////////
		
		
	procedure newIngredient(nIngrediente:tnIngredient;cant:tQuantity;gluten:tGluten;milk:tMilk;var lista:tListI);
	(*Entradas: nIngrediente, cant, gluten, milk, lista.
	Salida: La lista modificada con el nuevo ingrediente añadido.
	Objetivo: Añadir un nuevo ingrediente a la lista
	PostCD: Que la lista este inicializada
	*)
	var
		item:tItemI; //Item a insertar
		sCant:string; //Cantidad en string para imprimir más comodo
	begin
		Str(cant,sCant);
		imprimirLinea('Adding new ingredient:',nIngrediente,sCant,boolToString(gluten),boolToString(milk),'','');
		if(cant<=0)
			then imprimirError('Error adding New:','Invalid','Quantity','','')
			else begin
				if(findItemI(nIngrediente,lista)<>NULLI)
					then imprimirError('ERROR Adding New: Ingredient',nIngrediente,'already exists','','')
					else begin
						item.nIngredient := nIngrediente;
						item.quantity := cant;
						item.allergens.gluten := gluten;
						item.allergens.milk := milk;             //El elemento es creado y se prueba a ser insertado.
						if NOT(insertItemI(item,NULLI,lista))
							then imprimirLinea('WARNING: Out of memory','for','adding',nIngrediente,'ingredient','','');		 //No se pudo insertar el ingrediente			
					end;
			end;	
	end;
	
	
	procedure Modify(nIngredient:tnIngredient;quantity:tQuantity;var list:tListI);
	(*Entradas: nIngredient, quantity, lista.
	Salida: La lista modificada con la cantidad del ingrediente modificada.
	Objetivo: Modificar la cantidad de un ingrediente ya incluido en la lista 
	PostCD: Que la lista este inicializada
	*)
	var
		pos:tPosI; //posición del elemento
		item:tItemI;//item donde volcar los datos.
	begin
		if(quantity=0) then
			imprimirError('ERROR','Modifying:','invalid quantity','','') (*Caso cantidad = 0*)
		else begin
			pos:=findItemI(nIngredient,list);
			if(pos=NULLI) then
				imprimirError('ERROR Modifying: ingredient',nIngredient,'does not exist','','') (*Caso en el que no existe el ingrediente a modificar*)
			else begin
				item := getItemI(pos,list);
				item.quantity:=item.quantity+quantity;
				if(item.quantity=0) then begin
					imprimirLinea('Ingredient',nIngredient,'run out','of','stock','',''); (*El ingrediente se queda a 0, es eliminado.*)
					deleteAtPositionI(pos,List);
				end
				else if(item.quantity>0) then begin	
					updateItemI(list,pos,item);
					imprimirLinea('New','quantity for ingredient',nIngredient,':',IntToStr(item.quantity),'',''); (*El ingrediente es modificado normal*)
				end
				else
					imprimirError('ERROR Modifying:','not enough','quantity','','');(*El ingrediente no tiene suficiente cantidad para ser modificado*)
			end;
		end;
	end;
	
	
	procedure Remove(Quantity:tQuantity;var list:tListI);
	(*Entradas: Quantity, lista.
	Salida: La lista modificada con los ingredientes afectados eliminados.
	Objetivo: Eliminar todo ingrediente de la lista con una cantidad menor a la especificada
	PostCD: Que la lista este inicializada
	*)
	var
		pos:tPosI; //posición que recorre la lista
		item:tItemI;//item donde se vuelcan los datos
		cont:integer=0;//contador de eliminados
	begin
		imprimirLinea('Removing' ,'ingredients', 'with', 'quantity inferior to',IntToStr(Quantity),'','');
		if(isEmptyListI(list)) then
			imprimirLinea('No','ingredients','found' ,'in' ,'stock','','')
		else begin
			pos:=firstI(list);
			while(pos<>NULLI) do begin
				item:=getItemI(pos,list);
				if(item.quantity<Quantity) then begin
					writeln('* Ingredient ',item.nIngredient,': ',IntToStr(item.quantity));        //Busca el ingrediente con menos de X cantiad y los elimina, contando el numero de eliminados
					deleteAtPositionI(pos,list);
					cont:=cont+1;
				end;
				pos:=nextI(pos,list);
			end;
			if(cont=0) then
				imprimirLinea('No','ingredients','found' ,'in' ,'stock','','')
			else
				imprimirLinea('Number','of','ingredients','removed:',IntToStr(cont),'','');
		end;		
	end;
	
	
	procedure Allergens(gluten:boolean;milk:boolean;Lista:tListI);
	(*Entradas: gluten, milk, lista.
	Objetivo: Imprimir por pantalla el los ingredientes que contengan los alergenos especificados
	PostCD: Que la lista este inicializada
	*)
	var
		posI:tPosI; //posicion que recorre la lista
		item:tItemI; //item de la posicion que se imprime / obtienen datos
		exist,alergeno,printed:boolean; //Existen ingredientes con allergens y el ingrediente coincide con el criterio de busqueda
	begin
		exist:=false;
		if isEmptyListI(Lista)then
			imprimirLinea('No','stock','available','','','','')
		else begin
			if(NOT(gluten OR milk))	then
				imprimirError('ERROR','Showing allergens:','allergen not determined','','')
			else begin
				printed:=true;
				alergeno:=false;
				posI:=lastI(lista);
				while(posI<>NULLI) do begin
					item:=getItemI(posI,lista);
					if((milk)AND(item.allergens.milk = milk)OR(item.allergens.gluten = gluten)AND(gluten)) then //se comprueba que los tipos de alergenos buscados coinciden con el del ingrediente
						alergeno:=true;
					if(alergeno) 
					then begin
						if(printed) then begin							
							imprimirLinea('Ingredients','with',GOM(gluten,milk),':','','','');   //La función GOM decide si debe imprimir milk, gluten o allergenos.
							printed:=false;
						end;
						if((gluten)AND(milk)) then
							imprimirItem(item)
						else                                                               //Si lo que buscamos son los dos alergenos, se imprime como el stock
							writeln('* Ingredient ',item.nIngredient,': ',item.quantity); //si no normal
					end;
					exist:=exist OR alergeno; //guardamos en un booleano si ha existido alguno
					alergeno:=false;
					posI:=previousI(posI,lista); //y reiniciamos las variables del bucle.
				end; 
				if NOT exist then
						imprimirLinea('Current','stock','completely','allergen-free','','','');	
			end;								
		end;		
	end;	
	
	
	procedure Stock(withQuantity:boolean;Quantity:integer;lista:tListI);
	(*Entradas: withQuantity, Quantity, lista.
	Objetivo: Mostrar todos los ingredientes que estan actualmente en la lista, si se especifica una cantidad, muestra solo aquellos por debajo de esta cantidad.
	PostCD: Que la lista este inicializada*)
	var
		q:tPosI; //posicion en la lista de ingredientes
		item:tItemI; //conjunto de datos de una posicion
		printed:boolean; //variable que detecta si se ha impreso algo o no
		gluten,milk,total:integer; //numero de con gluten, con leche y en total
		pgluten,pmilk:real; //porcentaje con gluten y con leche
	begin
		gluten :=0; milk:=0; total:=0; pgluten := 0; pmilk := 0;
		if((Quantity<=0)AND(withQuantity))
			then imprimirError('ERROR in Stock:','invalid','quantity','','')
		else begin
			if (isEmptyListI(lista))
			then
				imprimirLinea('No','stock','available',' ',' ','','')
			else begin
				q:=lastI(lista);
				if(withQuantity)
					then
						imprimirLinea('Stock(<',IntToStr(Quantity),'):',' ',' ','','')
					else
						imprimirLinea('Stock',':',' ',' ',' ','','');
				while(q<>NULLI) do begin
					item:=getItemI(q,lista);
					if((item.quantity<Quantity)AND(withQuantity))
						then begin
							printed:=true;                      (*Caso con cantidad mínima.*)
							imprimirItem(item);
							total:=total+1;
							if(item.allergens.gluten)
								then gluten:=gluten+1;
							if(item.allergens.milk)
								then milk:=milk+1;
						end
						else begin
						 if(withQuantity=false) 
							then begin
								item:=getItemI(q,lista);
								imprimirItem(item);
								total:=total+1;
								if(item.allergens.gluten)
									then gluten:=gluten+1;               (*Caso sin cantidad minima*)
								if(item.allergens.milk)
									then milk:=milk+1;
							end;
						end;
						q:=previousI(q,lista);
						end;
					end;		
			if(withQuantity)AND(NOT(printed))
				then imprimirLinea('No','ingredients','below','the','threshold','','');
	
			if(printed)
				then begin
					if(withQuantity)
						then imprimirLinea('Number of ingredients','in stock (<',IntToStr(Quantity),'):',IntToStr(total),'','')
						else imprimirLinea('Number of ingredients','in','stock',':',IntToStr(total),'','');
					pgluten:=(gluten/total)*100;
					pmilk:=(milk/total)*100;
					writeln('      ',pgluten:0:1,'% contains gluten');
					writeln('      ',pmilk:0:1,'% contains milk');
				end;
			end;
		end;

	
	procedure newDesert(nPostre:tnDessert; sprecio:string ;var lista:tListD);
	(*Entradas: nDesserte, precio, listaD.
	Salida:El menu modificado, con el nuevo postre con su precio determinado,
	* insertado correctamente en la posicion determinada de la lista.
	Objetivo: Añadir un nuevo ingrediente a la lista
	PostCD: Que la lista este inicializada
	*)
	var
		item:tItemD; //Item a insertar
		Precio:real; //Cantidad en string para imprimir más comodo
		recipe:tListI; //receta de la posicion en la que esta, simplemente sera una lista vacia;
		format:TFormatSettings; //Parte de codigo dado en la implementación para especificar un separador decimal y evitar errores
	begin
		format.DecimalSeparator:='.';
		precio := StrToFloat(sprecio,format);
		if(precio<=0)
			then imprimirError('ERROR Adding new dessert:','Invalid','Price','','')
			else begin
				if(findItemD(nPostre,lista)<>NULLD)
					then imprimirError('ERROR Adding new dessert',nPostre,'already exists','','')
					else begin
						item.nDessert:=nPostre;
						item.price:=precio;
						createEmptyListI(recipe); //El postre se crea, si este no existe y se agrega a la lista
						item.recipe:=recipe;
						if NOT(insertItemD(item,lista))
							then imprimirLinea('WARNING: Out of memory','for','adding', 'dessert',nPostre,'','')  //Caso de si no se pudo agregar.
						else
							imprimirLinea('Adding new dessert to', 'menu: ', nPostre, sPrecio, ' euros','','');
					end;
			end;	
	end;


procedure addIngredient(nPostre:tnDessert; nIngrediente:tnIngredient; cant:tQuantity;var listaD:tListD; listaI:tListI );
	(*Entradas: nPostre, nIngredient, cant, listaD, listaI.
	Salida: La receta del postre modificada con el nuevo ingrediente añadido.
	Objetivo: Añadir un nuevo ingrediente a la receta de un postre,
	* el postre quedará actualizado con la nueva receta 
	PostCD: Que la lista este inicializada
	*)
	var
		p:tPosD; //Item a insertar
		sCant:string; //Cantidad en string para imprimir más comodo
		item:tItemI; //item a agregar, sacado de la despensa con todos sus datos
		itemD:tItemD; //Postre donde se ha decidido agregar
	begin
		Str(cant, sCant);
		p:=findItemD(nPostre,listaD);
		if(p=NULLD)
			then imprimirError('ERROR Adding Ingredient do dessert',nPostre,': dessert does not exist','','')
			else
				if(findItemI(nIngrediente,getItemD(p, listaD).recipe)<>NULLI)
					then imprimirError('ERROR Adding Ingredient to dessert',nPostre ,': ingredient ', nIngrediente,'already exists')
				else 
					if(cant<=0)
							then imprimirError('ERROR Adding Ingredient to dessert', nPostre ,': Invalid quantity','','')
							else begin
								item:=getItemI(findItemI(nIngrediente,listaI),listaI);
								itemD:=getItemD(p,listaD);
								item.quantity:=cant; //Se busca el ingrediente, se le pone la cantidad y se inserta, procedimiento muy parecidio a newIngredient o newDessert
								if NOT(insertItemI(item,NULLI,itemD.recipe))
									then imprimirLinea('WARNING: Out of memory','for','adding', 'dessert',nPostre,'','')	
								else begin
									imprimirLinea('Adding new ingredient to dessert',nPostre ,': ', nIngrediente, sCant, boolToString(item.allergens.gluten), boolToString(item.allergens.milk));
									updateItemD(listaD,p,itemD);
								end;
							end;
	end;


procedure TakeOff(nPostre:tnDessert; var listaD:tListD );
	(*Entradas: nPostre, listaD.
	Salida:La lista de postres con el postre eliminado.
	Objetivo: Elimina un postre determinado por su nombre de la lista de postres.
	PostCD: Que la lista este inicializada
	*)
	var 	
		p:tPosD; //posicion a eliminar
	begin
		p:=findItemD(nPostre,listaD);
		if p = NULLD
			then imprimirError('ERROR Taking off dessert ',nPostre,': dessert does not exist ','','')
		else begin
			deleteAtPositionD(findItemD(nPostre,listaD),listaD);
			imprimirLinea('Removing',' Dessert', nPostre,'from',' the menu','','');  
		end;
	end;

procedure Visualize(listaD:tListD);
	(*Entradas:listaD.
	Salida: Sin salida
	Objetivo: Imprime la pantalla la lista de postres
	PostCD: Que la lista este inicializada
	*)
	var
		p:tPosD;//Posicion que se va moviendo por la lista.	
	begin
		if isEmptyListD(listaD)
			then imprimirLinea('Menu','not','available','','','','')
		else begin
			p:=firstD(listaD);
			imprimirLinea('Menu',' ****','','','','','');
			while p <> NULLD do begin
				imprimirPostre(getItemD(p,listaD));
				p:=nextD(p,listaD);
			end;
		end;
	end;



procedure Order(nDessert:tnDessert;var listaD:tListD;var listaI:tListI);
	(*Entradas:nDesserte,ListaD, ListaI.
	Salida:Las listas modificadas en los casos apropiados.
	Objetivo: Inicia la realización de un postre, que buscará si los ingredientes en stock
	* son suficientes para hacer la receta, la determinará como haciendose, actualizará los elementos en stock y 
	* eliminará los agotados junto a los postres que contengan dichos elementos.
	PostCD: Que la lista este inicializada
	*)
var
	pos:tPosD; //posicion en la lista de postre
	itemD:tItemD; //item del postre del nombre buscado
	notAvaliable,notRemoved:boolean; //si el postre se puede o no realizar y si se ha o no actualizado el stock
	posI,q:tPosI; //posiciones en la lista de ingredientes y en la receta
	ingredienteStock,i:tItemI; //dos items diferentes de la lista de ingredientes, uno para la despensa y otro para la receta
begin
	pos:=findItemD(nDessert,listaD);
	
	if(pos=NULLD) then
		imprimirError('Error Order Not attended. Unknown dessert',nDessert,'','','') //Caso en el que el postre no existe
	else begin
		itemD:=getItemD(pos,listaD);
		notAvaliable:=imprimirReceta(itemD,listaI); //Funcion que imprime la receta de un postre determinado-
		if(notAvaliable) then begin
			writeln('**** Order not attended. Not enough Ingredients');  //No hay suficientes ingredientes en la despensa, el postre se elimina de la lista
			writeln('**** Removing dessert ',nDessert,' from the menu');
			deleteAtPositionD(pos,listaD);
		end
		else begin
			writeln('**** Order attended. Preparing dessert ',nDessert);
			posI:=firstI(itemD.recipe);
			while(posI<>NULLI) do begin
				i:=getItemI(posI,itemD.recipe);
				q:=findItemI(i.nIngredient,listaI);
				ingredienteStock:=getItemI(q,listaI); //Se buscan y se actualizan los ingredientes 1 a 1, si quedan a 0....
				ingredienteStock.quantity:= (ingredienteStock.quantity-i.quantity);
				updateItemI(listaI,q,ingredienteStock); 
				posI:=NextI(posI,itemD.recipe);
			end;
			notRemoved:= ActualizarStockyMenu(listaD,listaI); //esta funcion los elimina y elimina del menu los postres con ese ingrediente
			if(notRemoved) then
				writeln('**** Stock updated. No ingredients removed.')
		end;
	end;
end;


procedure readTasks(taskFile:string;var q:tQueue);
var 
    d: tItemQ; //item de la cola
    fileId : Text; //archivo de texto a imprimir
    line:string; //linea leida del archivo
    i:integer = 2; //cursor obviando el primer caracter

begin
		
	{$i-}
		assign(fileId, taskFile);
		reset(fileId);
	{$i+}
	if (IOResult<>0) then begin
		writeln('**** Reading. Error when trying to open ', taskFile);
		halt(1);
	end;

  While (not EOF(fileId)) do
    begin
        readln(fileId, line);
        d.code := line[1];
        d.parameter1:=SaveParameter(line,i);
        d.parameter2:=SaveParameter(line,i);
        d.parameter3:=SaveParameter(line,i);
        d.parameter4:=SaveParameter(line,i); //busca y trocea la linea en espacios y carga linea a linea el queue
        enqueue(q,d);
        i:=2;
    end;
    

end;

procedure execTask(var q:tQueue);
var
    d: tItemQ; //item de la cola
    DessertList:tListD; //lista de postres
    Despensa:tListI; //lista de la despensa
	quantity:tQuantity; //cantidad usada para llamar algunas funciones
	strquantity:string; //misma cantidad, en string
	milk,gluten,withQuantity:boolean; //diferentes boolean que hacen falta como entrada en procedimientos
begin
	    createEmptyListD(DessertList);  //Se inicializan las listas
	    createEmptyListI(Despensa);
	    while(NOT(isEmptyQueue(q))) do begin
		d:=front(q);
		dequeue(q);
		writeln('*******************************************');
 		writeln('TASK ', d.code,': ',d.parameter1,' ',d.parameter2,' ',d.parameter3,' ',d.parameter4);
		writeln('*******************************************');
		case d.code of
			'N', 'n': begin 
						
						val(d.parameter2,quantity);				
						//converts a string (true/false) to boolean
						if not TryStrToBool(d.parameter3, gluten) then begin
							writeln('**** Reading. Error reading data from queue');
							halt(1);
						end; 
						if not TryStrToBool(d.parameter2, milk)then begin
							writeln('**** Reading. Error reading data from queue');
							halt(1);
						end; 
						newIngredient(d.parameter1,quantity,gluten,milk,despensa);
					  end;	
			'M', 'm': begin 
						val(d.parameter2,quantity);
						Modify(d.parameter1,quantity,Despensa);
					  end;                                                                 //Se ejecuta el parametro
			'R', 'r': begin
						val(d.parameter1,quantity);
						Remove(quantity,despensa);
					  end;
			'A', 'a': begin 
						if not TryStrToBool(d.parameter1, gluten) then begin
							writeln('**** Reading. Error reading data from queue');
							halt(1);
						end; 
						if not TryStrToBool(d.parameter2, milk)then begin
							writeln('**** Reading. Error reading data from queue');
							halt(1);
						end;
						Allergens(gluten,milk,Despensa);  
					  end;
			'S', 's': begin 
						strquantity:=d.parameter1;
						if (strquantity <>'') then begin
							val(strquantity,quantity);
							withQuantity:=true;
						end
						else withQuantity:=false;
						Stock(withQuantity,quantity,Despensa);
					  end;
			'D', 'd': begin 
						newDesert(d.parameter1,d.parameter2,DessertList);
					  end;
			'I', 'i': begin
						val(d.parameter3,quantity);				
						addIngredient(d.parameter1,d.parameter2,quantity,DessertList,Despensa)
						end;
			'T', 't': begin 
						TakeOff(d.parameter1,DessertList);
					  end;
			'V', 'v': begin 
						Visualize(DessertList);
					  end;
			'O', 'o': begin 
						Order(d.parameter1,DessertList,Despensa);
					  end;
		end;
	end;
		DeleteList(Despensa,DessertList); //Cuando se vacia la cola, se limpian las listas
end;

var
queue:tQueue;	
BEGIN
	createEmptyQueue(queue);
	if (paramCount>0) then
		readTasks(ParamStr(1),queue)
	else
		readTasks('New.txt',queue);
	execTask(queue);

END.
