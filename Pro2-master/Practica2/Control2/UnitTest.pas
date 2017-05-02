program TestUnit;

//uses list;
//uses StaticList;
uses DessertList;

procedure print_list(L : tListD);
{prints a list, iterative version}
var p : tPosD;

begin
   write('(');
   if not isEmptyListD(L) then
   begin
      p := firstD(L);
      while p <> NULL do
      begin
		write(' ',getItemD(p, L).nDessert,' ');
		p := nextD(p, L)
      end;
   end;
   writeln(')');

end; { print_list_i }


var l:tListD;
    p,q:tPosD;
    d,d1: tItemD;
begin
	
	createEmptyListD(l);
	
	print_list(l);
	
	d1.nDessert :='tarta';

	insertItemD(d1, l);
	
	print_list(l);
	
	d1.nDessert := 'alfajores';
	insertItemD(d1,l);
	
	print_list(l);
	
	d1.nDessert := 'Crema';
	insertItemD(d1,l);
	
	print_list(l);
	
	d1.nDessert := 'Tostadas';
	insertItemD(d1,l);
	
	print_list(l);
	writeln('FindItem');

	p := findItemD('Crema', l);
	d := getItemD(p, l);
	
	d.price := 10.50;
	
	updateItemD(l,p,d);
	
	d := getItemD(p, l);
	
	writeln(d.nDessert);

	print_list(l);

	deleteAtPositionD(nextD(firstD(l),l), l);
	
	print_list(l);
	
	deleteAtPositionD(previousD(lastD(l),l), l);
	
	print_list(l);

	deleteAtPositionD(firstD(l),l);
	
	print_list(l);
	
	deleteAtPositionD(lastD(l),l);
	
	print_list(l);
	
	print_list(l);
	
end.
