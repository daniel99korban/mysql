# FUNÇÕES
-- essa função retorna quais privilegios dados a arquivo
DELIMITER $$
CREATE FUNCTION privilegio_acesso_arquivo(id INT) RETURNS VARCHAR(30)
BEGIN
	DECLARE nomeArq, perArq VARCHAR(100);
    IF NOT EXISTS(SELECT * FROM arquivoSo WHERE idArq=id) THEN
		RETURN 'O ARQUIVO NÃO FOI ENCONTRADO';
    END IF;
    -- precisa usar cursor se quiser retornar um conjunto de valores
    SET nomeArq = (SELECT nome FROM arquivoSo WHERE idArq=id);
    SET perArq = (SELECT permissoesArq FROM arquivoSo WHERE idArq=id);
    RETURN CONCAT(nomeArq,'  -->  ', perArq);
END $$
DELIMITER ;

DELIMITER $$
CREATE FUNCTION tamanhoDadosArmazenados() RETURNS INT
BEGIN
	DECLARE tamanho INT;
    SELECT sum(tamArq) into tamanho from arquivoSo;
    RETURN tamanho;
END $$
DELIMITER ;
-- call privilegio_acesso_arquivo(2, 'arquivo');
-- procedure ok

# TRIGGERS
#-------------------------------------
-- triger para atualizar a quantidade de arquivos no sistema
delimiter $$
create trigger trg_atualizar_qtdArqSO_AI after
insert on arquivoSO
for each row
begin
	update quantidadeDeArquivosSO
	set qtdArq = qtdArq + 1;
end $$
delimiter ;
show triggers;
-- TRIGGER OK

delimiter $$
create trigger trg_monitoramentoArquivos before update on arquivoSO
for each row
begin
	# descrever as alterações de um arquivo ou senha de usuario
    insert into logsSistema(usuario, datahora, operacao) 
    values(current_user, current_timestamp, "Update");
end $$

# PROCEDURES
#-------------------------------------
delimiter $$
create procedure inserir_usuario_admin(senha varchar(30), tipoUsu varchar(10), idUsuAdmin varchar(10), permissoesAdmin varchar(10), nomeAdmin varchar(30))
begin
	insert into usuario(permissoes, nome, tipoUsuario, idUsu) values(permissoesAdmin, nomeAdmin, tipoUsu, idUsuAdmin);
	insert into usuarioAdmin(senhaAdmin, idUsu) values(senha, idUsuAdmin);
end $$
delimiter ;

delimiter $$
create procedure inserir_usuario_comun(senha varchar(30), tipoUsu varchar(10), idUsu varchar(10), permissoesUsu varchar(10), nomeUsu varchar(30))
begin
	insert into usuario(permissoes, nome, tipoUsuario, idUsu) values(permissoesUsu, nomeUsu, tipoUsu, idUsu);
	insert into usuarioComun(senhaUsu, idUsu) values(senha, idUsu);
end $$
delimiter ;

DELIMITER $$
CREATE PROCEDURE get_usuariosComuns()
BEGIN
	SELECT u.permissoes, u.nome, u.tipoUsuario, u.idUsu
	FROM usuario as u JOIN usuarioComun as uc ON u.idUsu=uc.idUsu;
    END$$
DELIMITER ;

DELIMITER $$

CREATE PROCEDURE get_usuarioAdmin()
BEGIN
	SELECT u.permissoes, u.nome, u.tipoUsuario, u.idUsu
	FROM usuario as u JOIN usuarioAdmin as ua ON u.idUsu=ua.idUsu;
    END$$
DELIMITER ;




