<%@ page import="java.sql.*" %>
<%@ include file="inc/conexao.jsp" %>

<jsp:useBean id="contapagar" class="financeiro.ContasPagar" scope="page"></jsp:useBean>

<jsp:useBean id="pagar" class="financeiro.Pagar" scope="page"></jsp:useBean>

<jsp:useBean id="data" class="formatar.Datas" scope="page"></jsp:useBean>

<jsp:useBean id="lancamentos" class="financeiro.Lancamentos" scope="page"></jsp:useBean>

<jsp:useBean id="caixa" class="financeiro.LivroCaixa" scope="page"></jsp:useBean>

<jsp:useBean id="emprestimo" class="financeiro.Emprestimo" scope="page"></jsp:useBean>

<%
//Instancia um objeto do tipo Statment para realizar uma query
Statement st01 = con.createStatement();
Statement st02 = con.createStatement();
Statement st03 = con.createStatement();
%>

<%
//Instancia um objeto do tipo Resultset para receber o resultado de uma consulta
ResultSet rs01 = null;
ResultSet rs02 = null;
ResultSet rs03 = null;
%>


<%
//Atribui os valores do formulário ao objetos
contapagar.formPag.formPagID = Integer.parseInt(request.getParameter("formID"));
contapagar.favorecido = request.getParameter("favorecido");

	//Trata valor
	String valor = request.getParameter("valor");
	contapagar.valor = Float.parseFloat(valor.replace(",","."));
	
contapagar.data = request.getParameter("vencimento");
contapagar.vezes = Integer.parseInt(request.getParameter("vezes"));
contapagar.intervalo = Integer.parseInt(request.getParameter("intervalo"));

%>


	<%
	//Quebra a data e (dia , mes , ano)
	String dataVencimento = contapagar.data;
	String[] dt = new String[3];

	dt = dataVencimento.split("/");

		//Converte para Inteiro
		int ano = Integer.parseInt(dt[2]);
		int mes = Integer.parseInt(dt[1]);
		int dia = Integer.parseInt(dt[0]);
	%>
	
	

<%
//continua a atribuição de valores aos objetos
contapagar.data = String.valueOf(ano)+"-"+String.valueOf(mes)+"-"+String.valueOf(dia);
contapagar.usuario = (String)session.getAttribute("usuario");

%>


<%
//Cadastra uma Conta à Pagar na Base de Dados
st.execute(contapagar.cadastraConta());

//Pesquisa o ID da ultima Conta à Pagar inserida na Base de Dados
rs01 = st01.executeQuery(contapagar.ultimaConta());

//Atribui o ID do Conta à Pagar ao objeto ( pagar )
if(rs01.next()){
	pagar.conta.contaID = rs01.getInt("contapagarID");
}

%>


<%
//Atribui os valores ao objeto pagar

pagar.forma.formPagID = contapagar.formPag.formPagID;
pagar.status = "D";

	//Calcula o valor das parcelas
	float valorTotal = contapagar.valor;
	int quantidadeVezes = contapagar.vezes;
	
	pagar.valor = (valorTotal/quantidadeVezes);

pagar.de = contapagar.vezes;
%>


<%
//Atribui os valores ao objeto emprestimo
emprestimo.livro.livroID = Integer.parseInt(request.getParameter("livroID"));
emprestimo.usuario.usuarioID = Integer.parseInt((String)session.getAttribute("usuarioID"));
emprestimo.empresa.empresaID = 1;
emprestimo.valor = contapagar.valor;
emprestimo.contapagar.contaID = pagar.conta.contaID;
emprestimo.favorecido = contapagar.favorecido;
%>


<%
//Salva emprestimo na tabela Emprestimo
st.execute(emprestimo.insereEmprestimo());
%>


<%
//Pesquisa saldo atual do livro
caixa.livroID = emprestimo.livro.livroID;
rs02 = st02.executeQuery(caixa.saldoEmCaixa());

float saldoAtual = 0;
	
	//Verifica se a consulta retornou algum resultado
	if(rs02.next()){
		saldoAtual = rs02.getFloat("saldo");
	}
	
	//Atualiza a variavel de Saldo Atual do banco
	saldoAtual += emprestimo.valor;
	
	//Atualiza saldo na base de dados
	caixa.saldo = saldoAtual;
	st.execute(caixa.atualizaSaldo());
%>

<%
//Pesquisa o ultimo Emprestimo
rs03 = st03.executeQuery(emprestimo.ultimoEmprestimo());

	//Verifica se a pesquisa retornou algum resultado
	if(rs03.next()){
		lancamentos.emprestimo.emprestimoID = rs03.getInt("emprestimoID");
	}
%>

<%
//Gera um lançamento do tipo   'E'   para esse Emprestimo
lancamentos.contaPagar.contaID = emprestimo.contapagar.contaID;
lancamentos.livro.livroID = emprestimo.livro.livroID;
lancamentos.formaPag.formPagID = contapagar.formPag.formPagID;
lancamentos.valor = emprestimo.valor;
lancamentos.favorecido = emprestimo.favorecido;
lancamentos.observacao = " --- EMPRESTIMO --- ";
lancamentos.usuario.login = (String)session.getAttribute("usuario");

st.execute(lancamentos.emprestimos_());
%>



<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Gera conta a Pagar</title>
</head>
<body>

<%
//Variavel que irá recebe o intervalo de forma dinamica
int intervalo = 0;
%>

<table>


<%for(int i = 1; i <= contapagar.vezes; i++){ %>


<%
//Atribui a data de vencimento ao objeto
pagar.vencimento = data.calculaIntervalo(ano,mes,dia,intervalo);
pagar.parcela = i;
%>

<%
//Apagar Depois
String data1 = pagar.vencimento;
String data2 = data.converteDeData(data1);
%>

<tr>

<td> <%=i %>/<%=pagar.de %> </td><td> <%=data2%> </td><td> <%=pagar.valor %></td>

</tr>


<%
//A cada vez que passar no laço Insere no Pagar
st.execute(pagar.cadastraPagar());
%>

<%
//Incrementa o Intervalo entre as datas
intervalo += contapagar.intervalo; 
%>

<%} %>


<%
//Redireciona para a página de Cadastro de Emprestimos
response.sendRedirect("sis_insert_emprestimo.jsp?msg=1");//Caso de erro Comentar essa linha para enxergar todo o processo
%>

</table>
</body>
</html>