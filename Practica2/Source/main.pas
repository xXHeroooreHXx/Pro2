{
TITLE: PROGRAMMING II LABS  
SUBTITLE: Practical 2
AUTHOR 1: Julián Penedo Carrodeguas LOGIN 1: j.pcarrodeguas
AUTHOR 2: Pablo Ramos Muras LOGIN 2: pablo.muras 
GROUP: 4.2  
DATE: 02/05/2017
}


program Practica2;

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
		recipe : tListI;
		posI:tPosI;
		item:tItemI;
		stockQuantity:tQuantity;
	begin	
		writeln('**** Dessert',itemD.nDessert);
		recipe:=itemD.recipe;
		posI:=firstI(recipe);
		imprimirReceta:=false;
		while(posI<>NULLI) do begin
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
		writeln('++++ ',error1,' ',error2,' ',error3);
	end;
	
	procedure imprimirPostre(postre:titemD);
	var p:tPosI;
		milk:tMilk;
		gluten:tGluten;
		listaI:tListI;
	begin
		listaI:=postre.recipe;
		writeln(postre.nDessert,': ', postre.price,'.');
		p:=firstI(listaI);
		if p = NULLI
			then writeln('Recipe not included.')
		else begin
			milk:=false;
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
		posI:tPosI;
		posD:tPosD;
		itemI:tItemI;
		itemD:tItemD;
		printed:boolean = true;
	begin
		posI:=firstI(stock);
		ActualizarStockyMenu:=true;
		while(posI<>NULLI) do begin
			itemI:=getItemI(posI,stock);
			if(itemI.quantity = 0)then begin
				ActualizarStockyMenu:=false;
				writeln('**** Removing ingredient',itemI.nIngredient,'from stock');
				deleteAtPositionI(posI,stock);
				posD:=firstD(listaD);
				while(posD<>NULLD) do begin
					itemD:=getItemD(posD,listaD);
					if(findItemI(itemI.nIngredient,itemD.recipe)<>NULLI) then begin
						if(printed) then 
							writeln('**** Removing desserts that contains ',itemI.nIngredient);
						printed:=false;
						writeln('*Removing ',itemD.nDessert);
						deleteAtPositionD(posD,listaD);
						posD:=nextD(posD,listaD);
					end;

					
				end;
				if(printed)	then
					writeln('**** No more desserts affected')
			end;
			posI:=nextI(posI,stock);
		end;
	end;
	
	procedure DeleteList(var L:tListI; var D:tListD);
	var
		itemD:tItemD;
	begin
		while NOT isEmptyListI(L) do
			deleteAtPositionI(lastI(L),L);
		while NOT isEmptyListD(D) do begin
			itemD:=getItemD(LastD(D),D);
				while NOT isEmptyListI(itemD.recipe) do
					deleteAtPositionI(lastI(L),L);
			
		end;
			
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
						item.allergens.milk := milk;
						if NOT(insertItemI(item,NULLI,lista))
							then imprimirLinea('WARNING: Out of memory','for','adding',nIngrediente,'ingredient','','');					
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
					imprimirLinea('New','quantity for ingredient',nIngredient,':',IntToStr(quantity),'',''); (*El ingrediente es modificado normal*)
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
					writeln('* Ingredient ',item.nIngredient,': ',IntToStr(item.quantity));
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
		p:tPosI; //posicion que recorre la lista
		i:tItemI; //item donde se vuelcan los atos
		exist:boolean; //Existen ingredientes con allergens
	begin
	if isEmptyListI(Lista)then
			imprimirLinea('No','stock','available','','','','')
	else begin
		p:=firstI(Lista);
		exist:=false;
		if gluten then  
			if milk then begin																		(*Gluten & Milk*)
				while p <> NULLI do begin
					i:=getItemI(p,Lista);
					if (i.allergens.gluten) OR (i.allergens.milk) then begin
						if NOT exist then begin
							imprimirLinea('Ingredients','with','allergens:','','','','');
							exist:=true;
						end;
						imprimirItem(i);
						p:=nextI(p,lista);
					end;	
				end;
				if NOT exist then
					imprimirLinea('Current','stock','completely','allergen-free','','','');
				end
				else begin																		(*Gluten & NOT Milk*)
					while p <> NULLI do begin
						i:=getItemI(p,Lista);
						if i.allergens.gluten then begin
							if NOT exist then begin
								imprimirLinea('Ingredients','with','gluten:','','','','');
								exist:=true;
							end;
							writeln('* Ingredient ',i.nIngredient,': ',i.quantity);
						end;
						p:=nextI(p,lista);
	
					end;
					if NOT exist then
						imprimirLinea('Current','stock','completely','allergen-free','','','');
				end
			else									
				if milk then begin																		(*NOT Gluten & Milk*)
					while p <> NULLI do begin
						i:=getItemI(p,Lista);
						if i.allergens.milk then begin
							if NOT exist then begin
								imprimirLinea('Ingredients','with','milk:','','','','');
								exist:=true;
							end;
							writeln('* Ingredient ',i.nIngredient,': ',i.quantity);
						end;	
						p:=nextI(p,lista);
					end;
					if NOT exist then
						imprimirLinea('Current','stock','completely','allergen-free','','','');
				end
			else begin
				imprimirError('ERROR','Showing allergens:','allergen not determined','','');		(*NOT Gluten & NOT Milk*)
			end;
		end;
	end;
	
	procedure Stock(withQuantity:boolean;Quantity:integer;lista:tListI);
	(*Entradas: withQuantity, Quantity, lista.
	Objetivo: Mostrar todos los ingredientes que estan actualmente en la lista, si se especifica una cantidad, muestra solo aquellos por debajo de esta cantidad.
	PostCD: Que la lista este inicializada*)
	var
		q:tPosI;
		item:tItemI;
		printed:boolean;
		gluten,milk,total:integer;
		pgluten,pmilk:real;
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
							item:=getItemI(q,lista);
							imprimirItem(item);
							total:=total+1;
							if(item.allergens.gluten)
								then gluten:=gluten+1;               (*Caso sin cantidad minima*)
							if(item.allergens.milk)
								then milk:=milk+1;
							end;
						q:=previousI(q,lista);
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
	end;
	
	procedure newDesert(nPostre:tnDessert; precio:tPrice ;var lista:tListD);
	var
		item:tItemD; //Item a insertar
		sPrecio:string; //Cantidad en string para imprimir más comodo
		recipe:tListI;
	begin
		Str(precio,sPrecio);
		if(precio<=0)
			then imprimirError('ERROR Adding new dessert:','Invalid','Price','','')
			else begin
				if(findItemD(nPostre,lista)<>NULL)
					then imprimirError('ERROR Adding new dessert',nPostre,'already exists','','')
					else begin
						item.nDessert:=nPostre;
						item.price:=precio;
						createEmptyListI(recipe);
						item.recipe:=recipe;
						if NOT(insertItemD(item,lista))
							then imprimirLinea('WARNING: Out of memory','for','adding', 'dessert',nPostre,'','')
						else
							imprimirLinea('Adding new dessert to', 'menu: ', nPostre, sPrecio, ' euros','','');
					end;
			end;	
	end;


procedure addIngredient(nPostre:tnDessert; nIngrediente:tnIngredient; cant:tQuantity;var listaD:tListD; listaI:tListI );
	var
		p:tPosD; //Item a insertar
		sCant:string; //Cantidad en string para imprimir más comodo
		item:tItemI;
		itemD:tItemD;
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
								if NOT(insertItemI(item,NULLI,itemD.recipe))
									then imprimirLinea('WARNING: Out of memory','for','adding', 'dessert',nPostre,'','')	
								else begin
									imprimirLinea('Adding new ingredient to dessert',nPostre ,': ', nIngrediente, sCant, boolToString(item.allergens.gluten), boolToString(item.allergens.milk));
									updateItemD(listaD,p,itemD);
								end;
							end;
	end;


procedure TakeOff(nPostre:tnDessert; var listaD:tListD );
	var 	
		item:titemD;
		p:tPosD;
	begin
		p:=findItemD(nPostre,listaD);
		if p = NULLD
			then imprimirError('ERROR Taking off dessert ',nPostre,': dessert does not exist ','','')
		else begin
			item:=getItemD(findItemD(nPostre,listaD),listaD);
			while NOT isEmptyListI(item.recipe) do
				deleteAtPositionI(firstI(item.recipe),item.recipe);
			updateItemD(listaD,p,item);
			deleteAtPositionD(findItemD(nPostre,listaD),listaD);
			imprimirLinea('Removing',' Dessert', nPostre,'from',' the menu','','');
		end;
	end;

procedure Visualize(listaD:tListD);
	var
		p:tPosD;	
	begin
		if isEmptyListD(listaD)
			then imprimirLinea('Menu','not','available','','','','')
		else begin
			p:=firstD(listaD);
			imprimirLinea('Menu',' ****','','','','','');
			while p <> NULLD do
				imprimirPostre(getItemD(p,listaD));
				p:=nextD(p,listaD);
		end;
	end;



procedure Order(nDessert:tnDessert;var listaD:tListD;var listaI:tListI);
var
	pos:tPosD;
	itemD:tItemD;
	notAvaliable,notRemoved:boolean;
	posI:tPosI;
	ingredienteStock:tItemI;
	neededQuantity:tQuantity;
begin
	pos:=findItemD(nDessert,listaD);
	if(pos=NULLD) then
		imprimirError('Error Order Not attended. Unknown dessert',nDessert,'','','')
	else begin
		itemD:=getItemD(pos,listaD);
		notAvaliable:=imprimirReceta(itemD,listaI);
		if(notAvaliable) then begin
			writeln('**** Order not attended. Not enough Ingredients');
			writeln('**** Removing dessert',nDessert,'from the menu');
			deleteAtPositionD(pos,listaD);
		end
		else begin
			writeln('**** Order attended. Preparing dessert',nDessert);
			posI:=firstI(itemD.recipe);
			while(posI<>NULLI) do begin
				neededQuantity:=getItemI(posI,itemD.recipe).quantity;
				ingredienteStock:=getItemI(findItemI(getItemI(posI,itemD.recipe).nIngredient,listaI),listaI);
				ingredienteStock.quantity:= ingredienteStock.quantity-neededQuantity;
				updateItemI(listaI,posI,ingredienteStock);
				posI:=NextI(posI,listaI);
			end;
			notRemoved:= ActualizarStockyMenu(listaD,listaI);
			if(notRemoved) then
				writeln('**** Stock updated. No ingredients removed.')
		end;
	end;
end;


procedure readTasks(taskFile:string);
var 
	q:tQueue;
    d: tItemQ;
    fileId : Text;
    line:string;
    i:integer = 2;

begin
	
	createEmptyQueue(q);
	
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
        d.parameter4:=SaveParameter(line,i);
        enqueue(q,d);
        i:=2;
    end;
    
    while(NOT(isEmptyQueue(q))) do begin
		d:=front(q);
		writeln('*******************************************');
 		writeln('TASK ', d.code,': ',d.parameter1,' ',d.parameter2,' ',d.parameter3,' ',d.parameter4);
		writeln('*******************************************');
		case d.code of
			'N', 'n': begin 
					  
					  end;	
			'M', 'm': begin 
					  
					  end;
			'R', 'r': begin
		
					  end;
			'A', 'a': begin 

					  end;
			'S', 's': begin 

					  end;
			'D', 'd': begin 
					  
					  end;
			'I', 'i': begin
		
					  end;
			'T', 't': begin 

					  end;
			'V', 'v': begin 

					  end;
			'O', 'o': begin 

					  end;
		end;
	end;



end;

	
BEGIN
	
	if (paramCount>0) then
		readTasks(ParamStr(1))
	else
		readTasks('New.txt');
	

END.
