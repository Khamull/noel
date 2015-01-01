package financeiro;

import financeiro.LivroCaixa;
import financeiro.ContasPagar;
import cadastro.Empresa;
import cadastro.Usuario;

public class Emprestimo {
	public Emprestimo()
    {
        livro = new LivroCaixa();
        usuario = new Usuario();
        empresa = new Empresa();
        contapagar = new ContasPagar();
    }

    public String pesquisaEmprestimo()
    {
        return (new StringBuilder("SELECT * FROM emprestimo WHERE emprestimoID = '")).append(emprestimoID).append("'").toString();
    }

    public String detalheEmprestimo()
    {
        String busca = "SELECT contapagar.contapagarID, contapagar.formPagID, contapagar.vezes, contapagar.intervalo, ";
        busca = (new StringBuilder(String.valueOf(busca))).append("livrocaixa.livroID, livrocaixa.banco, ").toString();
        busca = (new StringBuilder(String.valueOf(busca))).append("formapagamento.formID, formapagamento.descricao, emprestimo.* ").toString();
        busca = (new StringBuilder(String.valueOf(busca))).append("FROM emprestimo INNER JOIN contapagar ON contapagar.contapagarID = emprestimo.contapagarID ").toString();
        busca = (new StringBuilder(String.valueOf(busca))).append("INNER JOIN livrocaixa ON livrocaixa.livroID =  emprestimo.livroID ").toString();
        busca = (new StringBuilder(String.valueOf(busca))).append("INNER JOIN formapagamento ON formapagamento.formID = contapagar.formPagID ").toString();
        busca = (new StringBuilder(String.valueOf(busca))).append("WHERE emprestimo.emprestimoID = '").append(emprestimoID).append("'").toString();
        return busca;
    }

    public String ultimoEmprestimo()
    {
        return "SELECT * FROM emprestimo ORDER BY emprestimoID DESC LIMIT 1";
    }

    public String insereEmprestimo()
    {
        String cadastraEmp = "INSERT INTO emprestimo ";
        cadastraEmp = (new StringBuilder(String.valueOf(cadastraEmp))).append("(livroID, usuarioID, empresaID, valor, contapagarID, favorecido) ").toString();
        cadastraEmp = (new StringBuilder(String.valueOf(cadastraEmp))).append("VALUES ").toString();
        cadastraEmp = (new StringBuilder(String.valueOf(cadastraEmp))).append("('").append(livro.livroID).append("', '").append(usuario.usuarioID).append("', '").append(empresa.empresaID).append("', '").append(valor).append("', '").append(contapagar.contaID).append("', '").append(favorecido).append("')").toString();
        return cadastraEmp;
    }

    public String mensagem(int numeroMsg)
    {
        switch(numeroMsg)
        {
        case 1: // '\001'
            return "Emprestimo Cadastrado com Sucesso!";

        case 2: // '\002'
            return "";

        case 3: // '\003'
            return "";

        case 4: // '\004'
            return "";

        case 5: // '\005'
            return "";
        }
        return "";
    }

    public int emprestimoID;
    public LivroCaixa livro;
    public Usuario usuario;
    public Empresa empresa;
    public float valor;
    public ContasPagar contapagar;
    public String favorecido;

}
