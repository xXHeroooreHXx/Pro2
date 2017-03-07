program TestUnit;

//uses list;
//uses StaticList;
uses DinamicList;

procedure print_list(L : tList);
{prints a list, iterative version}
var p : tPosL;

begin
   write('(');
   if not isEmptyList(L) then
   begin
      p := first(L);
      while p <> NULL do
      begin
		write(' ',getItem(p, L).nIngredient,' ');
		p := next(p, L)
      end;
   end;
   writeln(')');

end; { print_list_i }


var l:tList;
    p:tPosL;
    d,d1: tItem;

begin
	
	createEmptyList(l);
	
	print_list(l);
	
	d1.nIngredient :='flour';
	d1.quantity := 200;
	d1.allergens.gluten := true;
	d1.allergens.milk := false;
	insertItem(d1, NULL, l);
	
	print_list(l);
	
	d1.nIngredient := 'sugar';
	d1.quantity := 100;
	d1.allergens.gluten := false;
	d1.allergens.milk := false;
	insertItem(d1, first(l), l);
	
	print_list(l);
	
	d1.nIngredient := 'creme';
	d1.quantity := 50;
	d1.allergens.gluten := false;
	d1.allergens.milk := true;
	insertItem(d1, NULL, l);
	
	print_list(l);
	
	d1.nIngredient := 'marmelade';
	d1.quantity := 20;
	d1.allergens.gluten := true;
	d1.allergens.milk := false;
	insertItem(d1, next(first(l),l), l);
	
	print_list(l);
	
	d1.nIngredient := 'salt';
	d1.quantity := 72;
	d1.allergens.gluten := false;
	d1.allergens.milk := false;
	insertItem(d1, last(l), l);
	
	print_list(l);

	p := findItem('flour', l);

	d := getItem(p, l);
	
	writeln(d.nIngredient);
	
	d.quantity := 55;
	
	updateItem(l,p,d);
	
	d := getItem(p, l);
	
	writeln(d.nIngredient);
	
	print_list(l);

	deleteAtPosition(next(first(l),l), l);
	
	print_list(l);
	
	deleteAtPosition(previous(last(l),l), l);
	
	print_list(l);
	
	deleteAtPosition(first(l),l);
	
	print_list(l);
	
	deleteAtPosition(last(l),l);
	
	print_list(l);
	
	deleteAtPosition(first(l),l);

	print_list(l);
	
end.
