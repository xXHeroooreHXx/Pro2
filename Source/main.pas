program main;
	
	uses DynamicList,crt,sysutils;
	
	function IntToStr(int:integer):string;
	begin
		Str(int,IntToStr);
	end;
	
	function boolToString(bool:boolean):string;
	begin
		if(bool)
			then boolToString := 'true'
			else boolToString := 'false';
			
	end;
	
	procedure imprimirItem(item:tItem);
	begin
		writeln('* Ingredient ',item.nIngredient,': ',item.quantity);
		if(item.allergens.gluten)
		then writeln('      Contains gluten');
		
		if(item.allergens.milk)
		then writeln('      Contains milk');
	end;
	
	procedure imprimirLinea(linea1:string;linea2:string;linea3:string;linea4:string;linea5:string);
	begin
		writeln('**** ',linea1,' ',linea2,' ',linea3,' ',linea4,' ',linea5);
	end;
	
	procedure imprimirError(error1:string;error2:string;error3:string);
	begin
		writeln('++++ ',error1,' ',error2,' ',error3);
	end;
	
	procedure newIngredient(nIngrediente:string;cant:integer;gluten:boolean;milk:boolean;var lista:tList);
	var
		item:tItem;
		sCant:string;
	begin
		Str(cant,sCant);
		imprimirLinea('Adding new ingredient:',nIngrediente,sCant,boolToString(gluten),boolToString(milk));
		if(cant<=0)
			then imprimirError('Error adding New:','Invalid','Quantity')
			else begin
				if(findItem(nIngrediente,lista)<>NULL)
					then imprimirError('ERROR Adding New: Ingredient',nIngrediente,'already exists')
					else begin
						item.nIngredient := nIngrediente;
						item.quantity := cant;
						item.allergens.gluten := gluten;
						item.allergens.milk := milk;
						if NOT(insertItem(item,NULL,lista))
							then imprimirLinea('WARNING: Out of memory','for','adding',nIngrediente,'ingredient');					
					end;
			end;	
	end;
	
	procedure Modify(nIngredient:tnIngredient;quantity:tQuantity;var list:tList);
	var
		pos:tPosL;
		item:tItem;
	begin
		if(quantity=0) then
			imprimirError('ERROR','Modifying:','invalid quantity')
		else begin
			pos:=findItem(nIngredient,list);
			if(pos=NULL) then
				imprimirError('ERROR Modifying: ingredient',nIngredient,'does not exist')
			else begin
				item := getItem(pos,list);
				item.quantity:=item.quantity+quantity;
				if(item.quantity=0) then begin
					imprimirLinea('Ingredient',nIngredient,'run out','of','stock');
					deleteAtPosition(pos,List);
				end
				else if(item.quantity>0) then begin	
					updateItem(list,pos,item);
					imprimirLinea('New','quantity for ingredient',nIngredient,':',IntToStr(quantity));
				end
				else
					imprimirError('ERROR Modifying:','not enough','quantity');
			end;
		end;
	end;
	
	procedure Remove(minquantity:tQuantity;var list:tList);
	var
		pos:tPosL;
		item:tItem;
		cont:integer=0;
	begin
		imprimirLinea('Removing' ,'ingredients', 'with', 'quantity inferior to',IntToStr(minquantity));
		if(isEmptyList(list)) then
			imprimirLinea('No','ingredients','found' ,'in' ,'stock')
		else begin
			pos:=first(list);
			while(pos<>NULL) do begin
				item:=getItem(pos,list);
				if(item.quantity<minquantity) then begin
					writeln('* Ingredient ',item.nIngredient,': ',IntToStr(item.quantity));
					deleteAtPosition(pos,list);
					cont:=cont+1;
				end;
				pos:=next(pos,list);
			end;
			if(cont=0) then
				imprimirLinea('No','ingredients','found' ,'in' ,'stock')
			else
				imprimirLinea('Number','of','ingredients','removed:',IntToStr(cont));
		end;		
	end;
	
	procedure Allergens(gluten:boolean;milk:boolean;Lista:tList);
	var
		p:tPosL;
		i:tItem;
		exist:boolean;
	begin
	if isEmptyList(Lista)then
			imprimirLinea('No','stock','available','','')
	else begin
		p:=first(Lista);
		exist:=false;
		if gluten then  
			if milk then begin																		(*Gluten & Milk*)
				while p <> NULL do begin
					i:=getItem(p,Lista);
					if (i.allergens.gluten) OR (i.allergens.milk) then begin
						if NOT exist then begin
							imprimirLinea('Ingredients','with','allergens:','','');
							exist:=true;
						end;
						imprimirItem(i);
						p:=next(p,lista);
					end;	
				end;
				if NOT exist then
					imprimirLinea('Current','stock','completely','allergen-free','');
				end
				else begin																		(*Gluten & NOT Milk*)
					while p <> NULL do begin
						i:=getItem(p,Lista);
						if i.allergens.gluten then begin
							if NOT exist then begin
								imprimirLinea('Ingredients','with','gluten:','','');
								exist:=true;
							end;
							writeln('* Ingredient ',i.nIngredient,': ',i.quantity);
						end;
						p:=next(p,lista);
	
					end;
					if NOT exist then
						imprimirLinea('Current','stock','completely','allergen-free','');
				end
			else									
				if milk then begin																		(*NOT Gluten & Milk*)
					while p <> NULL do begin
						i:=getItem(p,Lista);
						if i.allergens.milk then begin
							if NOT exist then begin
								imprimirLinea('Ingredients','with','milk:','','');
								exist:=true;
							end;
							writeln('* Ingredient ',i.nIngredient,': ',i.quantity);
						end;	
						p:=next(p,lista);
					end;
					if NOT exist then
						imprimirLinea('Current','stock','completely','allergen-free','');
				end
			else begin
				imprimirError('ERROR','Showing allergens:','allergen not determined');		(*NOT Gluten & NOT Milk*)
			end;
		end;
	end;
	
	procedure Stock(filtro:boolean;minQuantity:integer;lista:tList);
	var
		q:tPosL;
		item:tItem;
		printed:boolean;
		gluten,milk,total:integer;
		pgluten,pmilk:real;
	begin
		gluten :=0; milk:=0; total:=0; pgluten := 0; pmilk := 0;
		if(minQuantity<=0)
		then imprimirError('ERROR in Stock:','invalid','quantity')
		else begin
		
			if (isEmptyList(lista))
			then
				imprimirLinea('No','stock','available',' ',' ')
			else begin
				q:=last(lista);
				if(filtro)
				then begin
					imprimirLinea('Stock(<',IntToStr(minQuantity),'):',' ',' ');
					while(q<>NULL) do begin
						item:=getItem(q,lista);
						if(item.quantity<minQuantity)
						then begin
							printed:=true;
							imprimirItem(item);
							total:=total+1;
						if(item.allergens.gluten)
							then gluten:=gluten+1;
						if(item.allergens.milk)
							then milk:=milk+1;
						end;
						q:=previous(q,lista);
						end;
				end			
				else begin
					imprimirLinea('Stock',':',' ',' ',' ');
					while(q<>NULL) do begin
						item:=getItem(q,lista);
						imprimirItem(item);
						total:=total+1;
						if(item.allergens.gluten)
							then gluten:=gluten+1;
						if(item.allergens.milk)
							then milk:=milk+1;
						q:=previous(q,lista);
					end;
				end;
			
			if(filtro)AND(NOT(printed))
				then imprimirLinea('No','ingredients','below','the','threshold');
	
			if(printed)
				then begin
					if(filtro)
						then imprimirLinea('Number of ingredients','in stock (<',IntToStr(minQuantity),'):',IntToStr(total))
						else imprimirLinea('Number of ingredients','in','stock',':',IntToStr(total));
					pgluten:=(gluten/total)*100;
					pmilk:=(milk/total)*100;
					writeln('      ',pgluten:0:1,'% contains gluten');
					writeln('      ',pmilk:0:1,'% contains milk');
				end;
			end;
		end;
	end;
	
	
	procedure readTasks(taskFile:string);
	var
	   fileId:Text; //file identifier
	   code: string; //code for each task[N, M, R, S or A]
	   line:string; //each line in the file
	   name:string; //name of ingredient
	   quantity:integer; //quantity of the ingredient
	   allergen1: string; // string "true" or "false" to indicate if the ingredient contains gluten
	   allergen2: string; // string "true" or "false"to indicate if the ingredient contains milk
	   strquantity:string; //string to convert to quantity
	   withQuantity: boolean; //indicates the operation S includes a quantity
	   gluten: boolean; //indicates if the ingredient has gluten
	   milk: boolean;//indicates if the ingredient has milk
	   lista:tList;
	   //ADD VARIABLES IF YOU NEED THEM
	   	
		
	begin
	   createEmptyList(lista);
	   {$i-}
	   assign(fileId, taskFile);
	   reset(fileId);
	   {$i+}
	   if (IOResult<>0) then begin
	   		writeln('**** Reading. Error when trying to open ', taskFile);
	   		halt(1);
	   end;
	
	  //Read all lines in file
	   While (not EOF(fileId))  do
	   begin
	      readln(fileId, line);
	      code:=trim(copy(line,1,2));
	      writeln('*******************************************');
	      writeln('Task ',line);
	      writeln('*******************************************');
	      //Select the proper arguments from each line of the file
	      case code[1] of
			'N', 'n': begin 
						name:=(trim(copy(line,3,12))); 
						val(trim(copy(line,17,7)),quantity);				
						allergen1:=trim(copy(line,23,6));
						allergen2:=trim(copy(line,29,6));
						//converts a string (true/false) to boolean
						if not TryStrToBool(allergen1, gluten) then begin
							writeln('**** Reading. Error reading data from ', taskFile);
							halt(1);
						end; 
						if not TryStrToBool(allergen2, milk)then begin
							writeln('**** Reading. Error reading data from ', taskFile);
							halt(1);
						end; 
						newIngredient(name,quantity,gluten,milk,lista);
					  end;
			'M', 'm': begin 
						name:=trim(copy(line,3,12)); 
						val(trim(copy(line,17,7)),quantity);
						Modify(name,quantity,lista);
					  end;
			'R', 'r': begin
						val(trim(copy(line,3,7)),quantity);
						Remove(quantity,lista);
					  end;
			'A', 'a': begin 
						allergen1:=trim(copy(line,3,6));
						allergen2:=trim(copy(line,9,6));
											//converts a string (true/false) to boolean
						if not TryStrToBool(allergen1, gluten) then begin
							writeln('**** Reading. Error reading data from ', taskFile);
							halt(1);
						end; 
						if not TryStrToBool(allergen2, milk)then begin
							writeln('**** Reading. Error reading data from ', taskFile);
							halt(1);
						end;
						Allergens(gluten,milk,lista);  
					  end;
			'S', 's': begin 
						strquantity:=trim(copy(line,3,7));
						if (strquantity <>'') then begin
							val(strquantity,quantity);
							withQuantity:=true;
						end
						else withQuantity:=false;
						Stock(withQuantity,quantity,lista);
					  end;
		end;
		
			   
	
		//EXECUTE TASK 
	    //...
		
		end; (*while*)
	
	end; 
	
	
	// ---------------------------------------------------------------------------------
	
	BEGIN
	
		if (paramCount>0) then
			readTasks(ParamStr(1))
		else
			readTasks('new.txt');
	

END.
