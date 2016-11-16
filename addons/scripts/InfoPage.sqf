// infoPage.sqf
// by CRE4MPIE
// ver 0.1
// 2015-02-01 01:20pm
// contributions from BIStudio Forums, by CRE4MPIE

sleep 30;   //delay before message is displayed after logging in
	
_text = "
<t align='center'><t shadow= 1 shadowColor='#000000'><t size='1.2'><t color='#ff0000'>Traitors Team Wasteland Altis</t>
<br />
<br />
<t align='center'><t size='1.2'><t shadow= 1 shadowColor='#000000'>Atalhos do Teclado</t><br />
<br />
<t align='left'><img size='2' shadow = 0 image='mapConfig\img\windows.paa'/></t><t align='left'><t size='1'><t shadow= 1 shadowColor='#000000'> Nomes dos Jogadores</t><br />
<t align='left'><img size='2' shadow = 0 image='mapConfig\img\end.paa'/></t><t align='left'><t size='1'><t shadow= 1 shadowColor='#000000'> Inserir/Remover Fones</t><br />
<t align='left'><img size='2' shadow = 0 image='mapConfig\img\v.paa'/></t><t align='left'><t size='1'><t shadow= 1 shadowColor='#000000'> Abrir/Cortar Pára-quedas</t><br />
<t align='left'><img size='2' shadow = 0 image='mapConfig\img\h.paa'/></t><t align='left'><t size='1'><t shadow= 1 shadowColor='#000000'> Coldre de Arma</t><br />
<t align='left'><img size='2' shadow = 0 image='mapConfig\img\del.paa'/></t><t align='left'><t size='1'><t shadow= 1 shadowColor='#000000'> Ejeção de Emergência</t><br />
<br />
<t align='center'><t size='1.2'><t shadow= 1 shadowColor='#0000ff'>Divirta-se e respeite os outros jogadores. Hacking ou exploit e você vai ser banido.</t>
<br />
<t align='center'><t size='1.2'><t shadow= 1 shadowColor='#000000'>Teamspeak  ts3.traitors.com.br</t>
<br />
<t align='center'><img size='6' shadow = 0 image='mapConfig\logo.paa'/></t>";

hint parseText format ["<t align='center'>Bem-vindo %2</t><br />%1",_text, name player];
 