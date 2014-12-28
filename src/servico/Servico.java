// Decompiled by Jad v1.5.8g. Copyright 2001 Pavel Kouznetsov.
// Jad home page: http://www.kpdus.com/jad.html
// Decompiler options: packimports(3) 
// Source File Name:   Servico.java

package servico;

import cadastro.*;
import pdv.FormaPagamento;

public class Servico
{

    public Servico()
    {
        cliente = new Cliente();
        empresa = new Empresa();
        formaPagamento = new FormaPagamento();
        usuario = new Usuario();
    }

    public String pesquisaServico()
    {
        String pesquisaEmp = "SELECT cliente.clienteID, cliente.clienteNomeFantasia, servico.* ";
        pesquisaEmp = (new StringBuilder(String.valueOf(pesquisaEmp))).append("FROM servico INNER JOIN cliente ON cliente.clienteID = servico.clienteID ").toString();
        pesquisaEmp = (new StringBuilder(String.valueOf(pesquisaEmp))).append("WHERE servico.servicoID = '").append(servicoID).append("'").toString();
        return pesquisaEmp;
    }

    public String pesquisaServicoEmpresa()
    {
        String pesquisaEmp = "SELECT cliente.clienteID, cliente.clienteNomeFantasia, servico.* ";
        pesquisaEmp = (new StringBuilder(String.valueOf(pesquisaEmp))).append("FROM servico INNER JOIN cliente ON cliente.clienteID = servico.clienteID ").toString();
        pesquisaEmp = (new StringBuilder(String.valueOf(pesquisaEmp))).append("WHERE servico.servicoID = '").append(servicoID).append("' AND servico.empresaID = '").append(empresa.empresaID).append("'").toString();
        return pesquisaEmp;
    }

    public String listaServicos()
    {
        return "SELECT * FROM servico ORDER BY servicoID DESC";
    }

    public String listaServicosPendentes()
    {
        String listaServ = "SELECT cliente.clienteID, cliente.clienteNomeFantasia, servico.* ";
        listaServ = (new StringBuilder(String.valueOf(listaServ))).append("FROM servico INNER JOIN cliente ON cliente.clienteID = servico.clienteID ").toString();
        listaServ = (new StringBuilder(String.valueOf(listaServ))).append("WHERE servico.status = 'M' AND servico.empresaID = '").append(empresa.empresaID).append("' ORDER BY servico.servicoID DESC").toString();
        return listaServ;
    }

    public String pesquisaPorCliente(String keyword)
    {
        String listaServ = "SELECT cliente.clienteID, cliente.clienteNomeFantasia, servico.* ";
        listaServ = (new StringBuilder(String.valueOf(listaServ))).append("FROM servico INNER JOIN cliente ON cliente.clienteID = servico.clienteID ").toString();
        listaServ = (new StringBuilder(String.valueOf(listaServ))).append("WHERE servico.status = 'M' AND servico.empresaID = '").append(empresa.empresaID).append("' ").toString();
        listaServ = (new StringBuilder(String.valueOf(listaServ))).append("AND cliente.clienteNomeFantasia LIKE '%").append(keyword).append("%' ORDER BY servico.servicoID DESC").toString();
        return listaServ;
    }

    public String servicosFechados(String dataInicial, String dataFinal)
    {
        String busca = "SELECT formapagamento.formID, formapagamento.descricao, ";
        busca = (new StringBuilder(String.valueOf(busca))).append("cliente.clienteID, cliente.clienteNomeFantasia, ").toString();
        busca = (new StringBuilder(String.valueOf(busca))).append("servico.* FROM servico ").toString();
        busca = (new StringBuilder(String.valueOf(busca))).append("INNER JOIN formapagamento ON formapagamento.formID = servico.formPagID ").toString();
        busca = (new StringBuilder(String.valueOf(busca))).append("LEFT JOIN cliente ON cliente.clienteID = servico.clienteID ").toString();
        busca = (new StringBuilder(String.valueOf(busca))).append("WHERE servico.dataFim BETWEEN '").append(dataInicial).append("' AND '").append(dataFinal).append(" 23:59:59").append("' ").toString();
        busca = (new StringBuilder(String.valueOf(busca))).append("AND servico.status = 'F' AND servico.empresaID = '").append(empresa.empresaID).append("' ").toString();
        busca = (new StringBuilder(String.valueOf(busca))).append("ORDER BY dataFim DESC").toString();
        return busca;
    }

    public String ultimoServico()
    {
        return "SELECT * FROM servico ORDER BY servicoID DESC LIMIT 1";
    }

    public String cadastraServico()
    {
        String salvaServ = "INSERT INTO servico ";
        salvaServ = (new StringBuilder(String.valueOf(salvaServ))).append("(clienteID, empresaID, descricao, dataInicio, valor, usuario) ").toString();
        salvaServ = (new StringBuilder(String.valueOf(salvaServ))).append("VALUES ").toString();
        salvaServ = (new StringBuilder(String.valueOf(salvaServ))).append("('").append(cliente.clienteID).append("', '").append(empresa.empresaID).append("', '").append(descricao).append("', '").append(dataInicio).append("', '").append(valor).append("', '").append(usuario.usuarioID).append("')").toString();
        return salvaServ;
    }

    public String completaServico()
    {
        String completa = "UPDATE servico ";
        completa = (new StringBuilder(String.valueOf(completa))).append("SET formPagID = '").append(formaPagamento.formPagID).append("', vezes = '").append(vezes).append("', ").toString();
        completa = (new StringBuilder(String.valueOf(completa))).append("valor = '").append(valor).append("', entrada = '").append(entrada).append("', troco = '").append(troco).append("', desconto = '").append(desconto).append("', status = 'F' ").toString();
        completa = (new StringBuilder(String.valueOf(completa))).append("WHERE servicoID = '").append(servicoID).append("'").toString();
        return completa;
    }

    public String atualizaServico()
    {
        String alterServ = "UPDATE servico ";
        alterServ = (new StringBuilder(String.valueOf(alterServ))).append("SET descricao = '").append(descricao).append("' ").toString();
        alterServ = (new StringBuilder(String.valueOf(alterServ))).append("WHERE servicoID = '").append(servicoID).append("'").toString();
        return alterServ;
    }

    public String atualizaValorServico()
    {
        String alterServ = "UPDATE servico ";
        alterServ = (new StringBuilder(String.valueOf(alterServ))).append("SET valor = '").append(valor).append("' ").toString();
        alterServ = (new StringBuilder(String.valueOf(alterServ))).append("WHERE servicoID = '").append(servicoID).append("'").toString();
        return alterServ;
    }

    public String visualizado()
    {
        return (new StringBuilder("UPDATE servico SET visualizacao = 'S' WHERE servicoID = '")).append(servicoID).append("'").toString();
    }

    public String naoVisualizado()
    {
        return (new StringBuilder("UPDATE servico SET visualizacao = 'N' WHERE servicoID = '")).append(servicoID).append("'").toString();
    }

    public String excluiServico()
    {
        return (new StringBuilder("DELETE FROM servico WHERE servicoID = '")).append(servicoID).append("'").toString();
    }

    public String mensagem(int numeroMsg)
    {
        switch(numeroMsg)
        {
        case 1: // '\001'
            return "Servi\347o Cadastrado com Sucesso!";

        case 2: // '\002'
            return "Servi\347o Atualizado com Sucesso!";

        case 3: // '\003'
            return "Servi\347o Excluido com Sucesso!";

        case 4: // '\004'
            return "Confirmado a Visualiza\347\343o";

        case 5: // '\005'
            return "";
        }
        return "";
    }

    public int servicoID;
    public Cliente cliente;
    public Empresa empresa;
    public String descricao;
    public FormaPagamento formaPagamento;
    public float entrada;
    public float troco;
    public int vezes;
    public float desconto;
    public String dataInicio;
    public String dataFim;
    public float valor;
    public Usuario usuario;
}
