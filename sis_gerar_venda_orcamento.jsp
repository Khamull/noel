<%//@ page errorPage="index.jsp?erro=3" %>
<%@ page import="java.sql.*" %>
<%@ include file="inc/conexao.jsp" %>

<jsp:useBean id="venda" class="pdv.Venda" scope="page"></jsp:useBean>
 
<jsp:useBean id="caixa" class="caixaloja.Caixa" scope="page"></jsp:useBean>

<jsp:useBean id="orcamento" class="pdv.Orcamento" scope="page"></jsp:useBean>

<jsp:useBean id="item" class="pdv.OrcamentoItem" scope="page"></jsp:useBean>

<jsp:useBean id="itemVenda" class="pdv.VendaItem" scope="page"></jsp:useBean>

<jsp:useBean id="estoque" class="cadastro.Estoque" scope="page"></jsp:useBean>

<jsp:useBean id="produtoEstoque" class="cadastro.ProdutoEstoque" scope="page"></jsp:useBean>

<%
//Instancia um Objeto do tipo Statement para ajudar na query
Statement st02 = con.createStatement();
Statement st03 = con.createStatement();
Statement st04 = con.createStatement();
%>
 
<%
//Instancia Objeto do tipo ResultSet para ser alimentado com o resultado da Consulta
ResultSet rs = null;
ResultSet rs01 = null;
ResultSet rs02 = null;
ResultSet rs03 = null;
ResultSet rs04 = null;
%> 
 
 
<%
//Recuperar dados do Or�amento para inser��o dos itens na venda orcamentoID
//Verifica se foi passado vendaID como parametro via URL
if(request.getParameter("orcamentoID")!=null){
	item.orcamento.orcamentoID = Integer.parseInt(request.getParameter("orcamentoID"));
	orcamento.orcamentoID = Integer.parseInt(request.getParameter("orcamentoID"));
}else{
	response.sendRedirect("sis_menu.jsp");
}

rs03 = st03.executeQuery(item.listaItensPorIDParaVenda());//Recupera todos os itens do Or�amento

//ANTES DE CRIAR UMA NOVA VENDA OU ABRIR UMA J� EXISTENTE
//VERIFICA SE FOI FEITA A ABERTURA DO CAIXA COM O LOGIN DO
//USUARIO QUE EST� LOGADO NO MOMENTO

//Atribui o nome do usuario ao objeto caixa para realizar
//a consulta posteriormente
caixa.usuario.login = (String)session.getAttribute("usuario");

//Faz a consulta na Base de Dados
rs02 = st02.executeQuery(caixa.verificaCaixa());


//Caso n�o haja um caixa aberto com esse usu�rio que est� logado
//ser� redirecionado para a p�gina de menu dando a mensagem ao usu�rio.
if(rs02.next()){
	//Continua executando a p�gina
%>
 
 
<%
//Atribui o login do usuario logado ao objeto usuario
venda.usuario.login = (String)session.getAttribute("usuario");


//verifica se j� tem uma venda Aberta com esse usuario do Sistema
rs = st.executeQuery(venda.vendaAberta());

//Caso tenha uma Aberta direciona para a p�gina de venda sem abrir uma nova
if(rs.next()){
	itemVenda.venda.vendaID 		= Integer.parseInt(rs.getString("vendaID"));
	//Adicionar Produtos do Or�amento a Venda
	while(rs03.next()){
		//Recupera valores do formul�rio para salvar como Item da Venda
		
		itemVenda.produto.produtoID 	= Integer.parseInt(rs03.getString("produtoID"));
		itemVenda.produto.nome 		= rs03.getString("nome");
		itemVenda.produto.preco 		= Float.parseFloat(rs03.getString("valor"));
		itemVenda.quantidade 		= Float.parseFloat(rs03.getString("quantidade"));
		itemVenda.total 				= Float.parseFloat(rs03.getString("total"));
		
		//Executa a Query q ir� salvar o item no banco de dados
		st.execute(itemVenda.salvaItem());
		//Pesquisa Quantidades do Estoque do Produto em Quest�o
		produtoEstoque.produto.produtoID = Integer.parseInt(rs03.getString("produtoID"));
		produtoEstoque.empresa.empresaID = Integer.parseInt((String)session.getAttribute("empresaID"));
		
		//Realiza a pesquisa da quantidade de itens no estoque referente a esse produto na unidade em que est� logado
		rs04 = st04.executeQuery(produtoEstoque.pesquisaEstoque());
		String estoqueParcial = "";
		if(rs04.next()){
			estoqueParcial = rs04.getString("quantidade");
		}
		
		//Subtrai quantidade adicionada ao pedido do Estoque
		estoque.produto.estoque = Float.parseFloat(estoqueParcial) - item.quantidade;
		estoque.produto.produtoID = Integer.parseInt(rs03.getString("produtoID"));
		st.execute(estoque.alteraEstoque());
		
		//Subtrai quantidade adicionao ao pedido do produtoEstoque (do estoque individual do produto por Unidade)
		produtoEstoque.produto.produtoID = estoque.produto.produtoID;
		produtoEstoque.empresa.empresaID = Integer.parseInt((String)session.getAttribute("empresaID"));
		produtoEstoque.quantidade = Float.parseFloat(estoqueParcial) - item.quantidade;
		st.execute(produtoEstoque.alteraEstoque());
	}
	response.sendRedirect("sis_pdv.jsp?vendaID="+itemVenda.venda.vendaID);
	
}else{
	//Sen�o abre uma nova VENDA na tabela venda e direciona para a p�gina de venda
	
	//Atribui o ID da empresa ao objeto
	venda.empresa.empresaID = Integer.parseInt((String)session.getAttribute("empresaID"));
	
	st.execute(venda.cadastraVenda());
	
	rs01 = st.executeQuery(venda.vendaAberta());
	if(rs01.next()){
		itemVenda.venda.vendaID 		= Integer.parseInt(rs01.getString("vendaID"));
	}
	while(rs03.next()){
		
		//Recupera valores do formul�rio para salvar como Item da Venda
		//itemVenda.venda.vendaID 		= Integer.parseInt(rs.getString("vendaID"));
		itemVenda.produto.produtoID 	= Integer.parseInt(rs03.getString("produtoID"));
		itemVenda.produto.nome 		= rs03.getString("nome");
		itemVenda.produto.preco 		= Float.parseFloat(rs03.getString("valor"));
		itemVenda.quantidade 		= Float.parseFloat(rs03.getString("quantidade"));
		itemVenda.total 				= Float.parseFloat(rs03.getString("total"));
		
		//Executa a Query q ir� salvar o item no banco de dados
		st.execute(itemVenda.salvaItem());
		//Pesquisa Quantidades do Estoque do Produto em Quest�o
		produtoEstoque.produto.produtoID = Integer.parseInt(rs03.getString("produtoID"));
		produtoEstoque.empresa.empresaID = Integer.parseInt((String)session.getAttribute("empresaID"));
		
		//Realiza a pesquisa da quantidade de itens no estoque referente a esse produto na unidade em que est� logado
		rs04 = st04.executeQuery(produtoEstoque.pesquisaEstoque());
		String estoqueParcial = "";
		if(rs04.next()){
			estoqueParcial = rs04.getString("quantidade");
		}
		
		//Subtrai quantidade adicionada ao pedido do Estoque
		estoque.produto.estoque = Float.parseFloat(estoqueParcial) - item.quantidade;
		estoque.produto.produtoID = Integer.parseInt(rs03.getString("produtoID"));
		st.execute(estoque.alteraEstoque());
		
		//Subtrai quantidade adicionao ao pedido do produtoEstoque (do estoque individual do produto por Unidade)
		produtoEstoque.produto.produtoID = estoque.produto.produtoID;
		produtoEstoque.empresa.empresaID = Integer.parseInt((String)session.getAttribute("empresaID"));
		produtoEstoque.quantidade = Float.parseFloat(estoqueParcial) - item.quantidade;
		st.execute(produtoEstoque.alteraEstoque());
	}
	response.sendRedirect("sis_pdv.jsp?vendaID="+itemVenda.venda.vendaID);	
}

%>

<%
}else{
	response.sendRedirect("sis_menu.jsp?msg=1");
}
%>