<%@ page import="java.sql.*" %>
<%@ include file="../inc/conexao.jsp" %>

<jsp:useBean id="empresa" class="cadastro.Empresa" scope="page"></jsp:useBean>

<jsp:useBean id="pagar" class="financeiro.Pagar" scope="page"></jsp:useBean>

<jsp:useBean id="receber" class="financeiro.Receber" scope="page"></jsp:useBean>

<jsp:useBean id="data" class="formatar.Datas" scope="page"></jsp:useBean>

<%
//Variavel que recebe o nivel do Usu�rio
String nivelUsuario = String.valueOf(session.getAttribute("nivel"));

//Se o nivel for restrito enviar para a p�gina de erro
if(nivelUsuario.equals("2") || nivelUsuario.equals("3") || nivelUsuario.equals("4") || nivelUsuario.equals("6")){
	response.sendRedirect("forbiden.jsp");
}
%>

<%
//Instancia um Objeto do tipo Statement para ajudar na Query
Statement st01 = con.createStatement();
Statement st02 = con.createStatement();
Statement st03 = con.createStatement();
%>

<%
//Instancia um Objeto do tipo ResultSet para receber o resultado de uma consulta
ResultSet rs01 = null;
ResultSet rs02 = null;
ResultSet rs03 = null;
%>

<%
//Pesquisa informa��es relacionadas � Empresa
empresa.empresaID = Integer.parseInt((String)session.getAttribute("empresaID"));
rs01 = st01.executeQuery(empresa.dadosGerais());
%>


<%
//Verifica se a consulta retornou algum valor e atribui �s Variaveis
String nomeFantasia = "";
String endereco = "";
String bairro = "";
String cidade = "";
String telefone = "";

	if(rs01.next()){
		nomeFantasia = rs01.getString("nomeFantasia");
		endereco = rs01.getString("rua")+", "+rs01.getString("numero");
		bairro = rs01.getString("bairro");
		cidade = rs01.getString("cidade");
		telefone = rs01.getString("telefone");
	}
%>


<%
//Variaveis que serao usadas para a Data
String diaInicio = "";
String diaFim = "";
String mesInicio = "";
String mesFim = "";
String anoInicio = "";
String anoFim = "";
String dataInicio = "";
String dataFim = "";

if(request.getParameter("razao") != null){
	pagar.razao = request.getParameter("razao");
}
//Verifica se foi passado parametro de data e Trata a Data
if(request.getParameter("diaA")!=null){
	diaInicio 	= request.getParameter("diaA");
	diaFim 		= request.getParameter("diaB");
	mesInicio 	= request.getParameter("mesA");
	mesFim		= request.getParameter("mesB");
	anoInicio	= request.getParameter("anoA");
	anoFim		= request.getParameter("anoB");
}

//Forma a Data para a Pesquisa
dataInicio = anoInicio+"-"+mesInicio+"-"+diaInicio;
dataFim = anoFim+"-"+mesFim+"-"+diaFim;

//Atribui a forma de pagamento a variavel
String formPagamento = request.getParameter("forma");

//verifica se foi passado uma forma de pagamento
if(formPagamento.equals("0")){
	rs02 = st02.executeQuery(pagar.pesquisaConta(dataInicio, dataFim));
	rs03 = st03.executeQuery(pagar.pesquisaConta(dataInicio, dataFim));
}else{
	//atribui a forma de pagamento ao Objeto pagar
	pagar.forma.formPagID = Integer.parseInt(formPagamento);
	rs02 = st02.executeQuery(pagar.pesquisaContaPorForma(dataInicio, dataFim));
	rs03 = st03.executeQuery(pagar.pesquisaContaPorForma(dataInicio, dataFim));
}
	
%>


<%
//Usado para Formatar o Valor para Moeda
Currency currency = Currency.getInstance("BRL");

DecimalFormat formato = new DecimalFormat("R$ #,##0.00");
%>


<%
//Ap�s ter feito as pesquisas Se tiver trazido algum valor, ser� somado abaixo o TOTAL
double valorTotal = 0;

while(rs03.next()){
	valorTotal += rs03.getDouble("valor");
}


//Formata para tipo Moeda
String valTotal = formato.format(valorTotal);
%>



<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@page import="java.util.Currency"%>
<%@page import="java.text.DecimalFormat"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title> - </title>

<style type="text/css">
 body, html{
	 margin:0px;
	 border:0px;
	 font-family:Arial, Helvetica, sans-serif;
	 font-size:12px;
 }
 
 .borda{
	border:1px dashed #666; 
	text-align:left;
	height:18px;
	padding:2px;
 }
</style>

</head>
<body bgcolor="#CCCCCC">

<!-- PRIMEIRA P�GINA -->
<table align="center" cellpadding="0" cellspacing="0" width="630" height="980" style="1px solid border:#000000; background-color:#FFFFFF">
 <tr>
  <td align="center" valign="middle">
  
  <!-- Borda 1 -->
   <table width="590" height="950" cellpadding="0" cellspacing="0" style="border:1px solid none" align="center">
    <tr>
     <td align="center" valign="top" height="120">
      <!-- Esse � o espa�o para que apare�a o cabe�alho -->
      <table width="585" height="120" border="0" align="center" cellpadding="0" cellspacing="0">
       <tr>
        <td width="140" rowspan="5" align="left" valign="top"><a href="javascript: window.print() "><img src="images/logo_relatorio.png" border="0" title="Iprimir Relatorio"></a></td>
        <td width="300" height="15" align="center"><font size="4"><strong><%=nomeFantasia %></strong></font></td>
        <td width="140" rowspan="5" align="center">&nbsp;</td>
       </tr>
       <tr>
        <td height="15" align="center"><strong><%=endereco %></strong></td>
        </tr>
       <tr>
        <td height="15" align="center"><strong><%=bairro %></strong></td>
        </tr>
       <tr>
        <td height="15" align="center"><strong><%=cidade %></strong></td>
        </tr>
       <tr>
        <td height="15" align="center"><strong><%=telefone %></strong></td>
        </tr>
       <tr>
        <td align="center" colspan="3"><hr></td>
       </tr>
       <tr>
        <td height="15" colspan="3" align="center"><strong>RELATORIO - CONTAS A PAGAR ( de <%=data.converteDeData(dataInicio) %>&nbsp;&nbsp; &agrave; &nbsp;&nbsp;<%=data.converteDeData(dataFim) %> ) - TOTAL: <%=valTotal%></strong></td>
       </tr>
       <tr>
        <td align="center" colspan="3"><hr></td>
       </tr>
      </table>
     </td>
    </tr>
    <tr>
     <td align="center" valign="top">
     
     <!-- ##########################   INICIO DO RELATORIO ######################## -->
      <table border="0" cellpadding="0" cellspacing="0" width="585" align="center">
      <%
      int ln = 1;
      while(rs02.next()){
      %>
      <%
      //Verifica se ja preecheu as 54 linhas e da um espa�amento
      if(ln == 55){
      %>
      <tr>
       <td colspan="4" height="170" valign="bottom">
       
       <table width="585" border="0" align="center" cellpadding="0" cellspacing="0">
       <tr>
        <td colspan="4" height="32"></td>
       </tr>
       <tr>
        <td width="140" rowspan="5" align="left" valign="top"><a href="javascript: window.print() "><img src="images/logo_relatorio.png" border="0" title="Iprimir Relatorio"></a></td>
        <td width="300" height="15" align="center"><font size="4"><strong><%=nomeFantasia %></strong></font></td>
        <td width="140" rowspan="5" align="center">&nbsp;</td>
       </tr>
       <tr>
        <td height="15" align="center"><strong><%=endereco %></strong></td>
        </tr>
       <tr>
        <td height="15" align="center"><strong><%=bairro %></strong></td>
        </tr>
       <tr>
        <td height="15" align="center"><strong><%=cidade %></strong></td>
        </tr>
       <tr>
        <td height="15" align="center"><strong><%=telefone %></strong></td>
        </tr>
       <tr>
        <td align="center" colspan="3"><hr></td>
       </tr>
       <tr>
        <td height="15" colspan="3" align="center"><strong>RELATORIO - CONTAS A PAGAR ( de <%=data.converteDeData(dataInicio) %>&nbsp;&nbsp; &agrave; &nbsp;&nbsp;<%=data.converteDeData(dataFim) %> ) - TOTAL: <%=valTotal%></strong></td>
       </tr>
       <tr>
        <td align="center" colspan="3"><hr></td>
       </tr>
      </table>
       
       </td>
      </tr>
      <%
      //Se ja tiver preenchido reinicializa o valor do contador
      ln = 1;
      }
      %>
       <tr>
        <td width="127" height="15" align="left"><strong>N&deg; Conta</strong></td>
        <td width="96" align="left"></td>
        <td width="223" align="left"><strong>Vencimento</strong></td>
        <td width="139" align="left"><strong>Status:</strong> 
        <%String statusData = data.verificaDataVencimento(rs02.getString("vencimento")); %>
        <%if(statusData.equals("igual")){ %>
         <font color="#009900">Vence Hoje</font>
        <%}else if(statusData.equals("menor")){ %>
         <font color="#FF0000">VENCIDA</font>
        <%}else if(statusData.equals("maior")){ %>
         <font color="#0000FF">A Vencer</font>
        <%} %>
        </td>
       </tr>
      <%ln++; %>
      <%
      //Verifica se ja preecheu as 54 linhas e da um espa�amento
      if(ln == 55){
      %>
      <tr>
       <td colspan="4" height="170" valign="bottom">
       
       <table width="585" border="0" align="center" cellpadding="0" cellspacing="0">
       <tr>
        <td colspan="4" height="32"></td>
       </tr>
       <tr>
        <td width="140" rowspan="5" align="left" valign="top"><a href="javascript: window.print() "><img src="images/logo_relatorio.png" border="0" title="Iprimir Relatorio"></a></td>
        <td width="300" height="15" align="center"><font size="4"><strong><%=nomeFantasia %></strong></font></td>
        <td width="140" rowspan="5" align="center">&nbsp;</td>
       </tr>
       <tr>
        <td height="15" align="center"><strong><%=endereco %></strong></td>
        </tr>
       <tr>
        <td height="15" align="center"><strong><%=bairro %></strong></td>
        </tr>
       <tr>
        <td height="15" align="center"><strong><%=cidade %></strong></td>
        </tr>
       <tr>
        <td height="15" align="center"><strong><%=telefone %></strong></td>
        </tr>
       <tr>
        <td align="center" colspan="3"><hr></td>
       </tr>
       <tr>
        <td height="15" colspan="3" align="center"><strong>RELATORIO - CONTAS A PAGAR ( de <%=data.converteDeData(dataInicio) %>&nbsp;&nbsp; &agrave; &nbsp;&nbsp;<%=data.converteDeData(dataFim) %> ) - TOTAL: <%=valTotal%></strong></td>
       </tr>
       <tr>
        <td align="center" colspan="3"><hr></td>
       </tr>
      </table>
       
       </td>
      </tr>
      <%
      //Se ja tiver preenchido reinicializa o valor do contador
      ln = 1;
      }
      %>
        <tr>
         <td height="15" align="left"><%=rs02.getString("contapagarID") %></td>
         <td align="left"></td>
         <td align="left"><%=data.converteDeData(String.valueOf(rs02.getString("vencimento")))  %></td>
         <td align="left"></td>
        </tr>
     <%ln++; %>
      <%
      //Verifica se ja preecheu as 54 linhas e da um espa�amento
      if(ln == 55){
      %>
      <tr>
       <td colspan="4" height="170" valign="bottom">
       
       <table width="585" border="0" align="center" cellpadding="0" cellspacing="0">
       <tr>
        <td colspan="4" height="32"></td>
       </tr>
       <tr>
        <td width="140" rowspan="5" align="left" valign="top"><a href="javascript: window.print() "><img src="images/logo_relatorio.png" border="0" title="Iprimir Relatorio"></a></td>
        <td width="300" height="15" align="center"><font size="4"><strong><%=nomeFantasia %></strong></font></td>
        <td width="140" rowspan="5" align="center">&nbsp;</td>
       </tr>
       <tr>
        <td height="15" align="center"><strong><%=endereco %></strong></td>
        </tr>
       <tr>
        <td height="15" align="center"><strong><%=bairro %></strong></td>
        </tr>
       <tr>
        <td height="15" align="center"><strong><%=cidade %></strong></td>
        </tr>
       <tr>
        <td height="15" align="center"><strong><%=telefone %></strong></td>
        </tr>
       <tr>
        <td align="center" colspan="3"><hr></td>
       </tr>
       <tr>
        <td height="15" colspan="3" align="center"><strong>RELATORIO - CONTAS A PAGAR ( de <%=data.converteDeData(dataInicio) %>&nbsp;&nbsp; &agrave; &nbsp;&nbsp;<%=data.converteDeData(dataFim) %> ) - TOTAL: <%=valTotal%></strong></td>
       </tr>
       <tr>
        <td align="center" colspan="3"><hr></td>
       </tr>
      </table>
       
       </td>
      </tr>
      <%
      //Se ja tiver preenchido reinicializa o valor do contador
      ln = 1;
      }
      %>
        <tr>
         <td height="15" align="left" colspan="2"><strong>Forma de Pagamento</strong></td>
         <td align="left"><strong>Parcela</strong></td>
         <td align="left"><strong></strong></td>
        </tr>
     <%ln++; %>
      <%
      //Verifica se ja preecheu as 54 linhas e da um espa�amento
      if(ln == 55){
      %>
      <tr>
       <td colspan="4" height="170" valign="bottom">
       
       <table width="585" border="0" align="center" cellpadding="0" cellspacing="0">
       <tr>
        <td colspan="4" height="32"></td>
       </tr>
       <tr>
        <td width="140" rowspan="5" align="left" valign="top"><a href="javascript: window.print() "><img src="images/logo_relatorio.png" border="0" title="Iprimir Relatorio"></a></td>
        <td width="300" height="15" align="center"><font size="4"><strong><%=nomeFantasia %></strong></font></td>
        <td width="140" rowspan="5" align="center">&nbsp;</td>
       </tr>
       <tr>
        <td height="15" align="center"><strong><%=endereco %></strong></td>
        </tr>
       <tr>
        <td height="15" align="center"><strong><%=bairro %></strong></td>
        </tr>
       <tr>
        <td height="15" align="center"><strong><%=cidade %></strong></td>
        </tr>
       <tr>
        <td height="15" align="center"><strong><%=telefone %></strong></td>
        </tr>
       <tr>
        <td align="center" colspan="3"><hr></td>
       </tr>
       <tr>
        <td height="15" colspan="3" align="center"><strong>RELATORIO - CONTAS A PAGAR ( de <%=data.converteDeData(dataInicio) %>&nbsp;&nbsp; &agrave; &nbsp;&nbsp;<%=data.converteDeData(dataFim) %> ) - TOTAL: <%=valTotal%></strong></td>
       </tr>
       <tr>
        <td align="center" colspan="3"><hr></td>
       </tr>
      </table>
       
       </td>
      </tr>
      <%
      //Se ja tiver preenchido reinicializa o valor do contador
      ln = 1;
      }
      %>
        <tr>
         <td height="15" align="left" colspan="2"><%=rs02.getString("descricao") %></td>
         <td align="left"><%=rs02.getString("parcela") %> / <%=rs02.getString("de") %></td>
         <td align="left"></td>
        </tr>
      <%ln++; %>
      <%
      //Verifica se ja preecheu as 54 linhas e da um espa�amento
      if(ln == 55){
      %>
      <tr>
       <td colspan="4" height="170" valign="bottom">
       
       <table width="585" border="0" align="center" cellpadding="0" cellspacing="0">
       <tr>
        <td colspan="4" height="32"></td>
       </tr>
       <tr>
        <td width="140" rowspan="5" align="left" valign="top"><a href="javascript: window.print() "><img src="images/logo_relatorio.png" border="0" title="Iprimir Relatorio"></a></td>
        <td width="300" height="15" align="center"><font size="4"><strong><%=nomeFantasia %></strong></font></td>
        <td width="140" rowspan="5" align="center">&nbsp;</td>
       </tr>
       <tr>
        <td height="15" align="center"><strong><%=endereco %></strong></td>
        </tr>
       <tr>
        <td height="15" align="center"><strong><%=bairro %></strong></td>
        </tr>
       <tr>
        <td height="15" align="center"><strong><%=cidade %></strong></td>
        </tr>
       <tr>
        <td height="15" align="center"><strong><%=telefone %></strong></td>
        </tr>
       <tr>
        <td align="center" colspan="3"><hr></td>
       </tr>
       <tr>
        <td height="15" colspan="3" align="center"><strong>RELATORIO - CONTAS A PAGAR ( de <%=data.converteDeData(dataInicio) %>&nbsp;&nbsp; &agrave; &nbsp;&nbsp;<%=data.converteDeData(dataFim) %> ) - TOTAL: <%=valTotal%></strong></td>
       </tr>
       <tr>
        <td align="center" colspan="3"><hr></td>
       </tr>
      </table>
       
       </td>
      </tr>
      <%
      //Se ja tiver preenchido reinicializa o valor do contador
      ln = 1;
      }
      %>
        <tr>
         <td height="15" align="left" colspan="2"><strong>Favorecido</strong></td>
         <td height="15" align="left" colspan="1"><strong>Despesa</strong></td>
         <td align="left"><strong>Valor</strong></td>
        </tr>
      <%ln++; %>
      <%
      //Verifica se ja preecheu as 54 linhas e da um espa�amento
      if(ln == 55){
      %>
      <tr>
       <td colspan="4" height="170" valign="bottom">
       
       <table width="585" border="0" align="center" cellpadding="0" cellspacing="0">
       <tr>
        <td colspan="4" height="32"></td>
       </tr>
       <tr>
        <td width="140" rowspan="5" align="left" valign="top"><a href="javascript: window.print() "><img src="images/logo_relatorio.png" border="0" title="Iprimir Relatorio"></a></td>
        <td width="300" height="15" align="center"><font size="4"><strong><%=nomeFantasia %></strong></font></td>
        <td width="140" rowspan="5" align="center">&nbsp;</td>
       </tr>
       <tr>
        <td height="15" align="center"><strong><%=endereco %></strong></td>
        </tr>
       <tr>
        <td height="15" align="center"><strong><%=bairro %></strong></td>
        </tr>
       <tr>
        <td height="15" align="center"><strong><%=cidade %></strong></td>
        </tr>
       <tr>
        <td height="15" align="center"><strong><%=telefone %></strong></td>
        </tr>
       <tr>
        <td align="center" colspan="3"><hr></td>
       </tr>
       <tr>
        <td height="15" colspan="3" align="center"><strong>RELATORIO - CONTAS A PAGAR ( de <%=data.converteDeData(dataInicio) %>&nbsp;&nbsp; &agrave; &nbsp;&nbsp;<%=data.converteDeData(dataFim) %> ) - TOTAL: <%=valTotal%></strong></td>
       </tr>
       <tr>
        <td align="center" colspan="3"><hr></td>
       </tr>
      </table>
       
       </td>
      </tr>
      <%
      //Se ja tiver preenchido reinicializa o valor do contador
      ln = 1;
      }
      %>
        <tr>
         <td height="15" align="left" colspan="2"><%=rs02.getString("favorecido") %></td>
         <td height="15" align="left" colspan="1"><%=rs02.getString("razao") %></td>
         <td align="left"><%=formato.format(rs02.getDouble("valor")) %></td>
        </tr>
     <%ln++; %>
      <%
      //Verifica se ja preecheu as 54 linhas e da um espa�amento
      if(ln == 55){
      %>
      <tr>
       <td colspan="4" height="170" valign="bottom">
       
       <table width="585" border="0" align="center" cellpadding="0" cellspacing="0">
       <tr>
        <td colspan="4" height="32"></td>
       </tr>
       <tr>
        <td width="140" rowspan="5" align="left" valign="top"><a href="javascript: window.print() "><img src="images/logo_relatorio.png" border="0" title="Iprimir Relatorio"></a></td>
        <td width="300" height="15" align="center"><font size="4"><strong><%=nomeFantasia %></strong></font></td>
        <td width="140" rowspan="5" align="center">&nbsp;</td>
       </tr>
       <tr>
        <td height="15" align="center"><strong><%=endereco %></strong></td>
        </tr>
       <tr>
        <td height="15" align="center"><strong><%=bairro %></strong></td>
        </tr>
       <tr>
        <td height="15" align="center"><strong><%=cidade %></strong></td>
        </tr>
       <tr>
        <td height="15" align="center"><strong><%=telefone %></strong></td>
        </tr>
       <tr>
        <td align="center" colspan="3"><hr></td>
       </tr>
       <tr>
        <td height="15" colspan="3" align="center"><strong>RELATORIO - CONTAS A PAGAR ( de <%=data.converteDeData(dataInicio) %>&nbsp;&nbsp; &agrave; &nbsp;&nbsp;<%=data.converteDeData(dataFim) %> ) - TOTAL: <%=valTotal%></strong></td>
       </tr>
       <tr>
        <td align="center" colspan="3"><hr></td>
       </tr>
      </table>
       
       </td>
      </tr>
      <%
      //Se ja tiver preenchido reinicializa o valor do contador
      ln = 1;
      }
      %>
       <tr>
       <td height="15" colspan="4" align="center"> - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - </td>
      </tr>
     <%ln++; %>
     <%} %>
       </table>
     <!-- ##########################     FIM DO RELATORIO ######################### -->
     
     </td>
    </tr>
   </table>
  <!-- Fim da Borda -->
  
  </td>
 </tr>
</table>
<!-- Fim da Primeira P�gina -->



</body>
</html>