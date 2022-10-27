-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema arquivosSO
-- -----------------------------------------------------

CREATE DATABASE IF NOT EXISTS arquivos_so;
drop database arquivos_so;
use arquivos_so;
show tables;

-- -----------------------------------------------------
-- Table `usuario`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `usuario` (
  `permissoes` ENUM('wrx', 'wr', 'r') NULL DEFAULT 'r',
  `nome` VARCHAR(30) NULL DEFAULT 'usuario',
  `tipoUsuario` ENUM('user','root'),
  `idUsu` INT NOT NULL,
  PRIMARY KEY (`idUsu`))
ENGINE = InnoDB;
select * from usuario;
truncate table usuario;
drop table usuario;
-- truncate table  ;
call get_usuariosComuns();
call get_usuarioAdmin();

-- -----------------------------------------------------
-- Table `usuarioAdmin`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `usuarioAdmin` (
  `senhaAdmin` VARCHAR(30) NOT NULL,
  `idUsu` INT NOT NULL,
  PRIMARY KEY (`idUsu`),
  FOREIGN KEY (`idUsu`) REFERENCES `usuario` (`idUsu`)
)
ENGINE = InnoDB;
select * from usuarioAdmin;
call inserir_usuario_admin('123admin', 'root', '1', 'wrx', 'danielKorban');
truncate table usuarioAdmin;
drop table usuarioAdmin;

-- -----------------------------------------------------
-- Table `usuarioComun`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `usuarioComun` (
  `senhaUsu` VARCHAR(30) NULL,
  `idUsu` INT NOT NULL,
  PRIMARY KEY (`idUsu`),
  FOREIGN KEY (`idUsu`) REFERENCES `usuario` (`idUsu`)
)
ENGINE = InnoDB;
call inserir_usuario_comun('12345', 'user','2', 'wr', 'João');
call inserir_usuario_comun('12sdf', 'user','3', 'wr', 'Maria');
call inserir_usuario_comun('@qwe12', 'user','4', 'r', 'Bento');
drop table usuarioComun;
truncate table usuarioComun;
select * from usuarioComun;

-- -----------------------------------------------------
-- Table `arquivoSO`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `arquivoSO` (
  `nome` VARCHAR(100) NULL DEFAULT 'undefined',
  `tipoArq` VARCHAR(10) NULL DEFAULT 'texto',
  `tamArq` INT NOT NULL DEFAULT 0,
  `permissoesArq` varchar(5) NULL,
  `idArq` INT NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`idArq`))
ENGINE = InnoDB;

 insert into arquivoSO(tamArq, permissoesArq) values(10, 'rwx');
 insert into arquivoSO(nome, tipoArq, tamArq, permissoesArq) values
 ('redacao', 'docx', 6, 'rw'), ('folha-de-pagamento', 'exel', 15, 'r'), ('agenda', 'exel', 3, 'rw');

select * from arquivoSO;
Select privilegio_acesso_arquivo(2) AS ARQUIVO_PERMISSOES;
select tamanhoDadosArmazenados() AS volumeArquivos;
drop table arquivoSO;
truncate table arquivoSO;

-- -----------------------------------------------------
-- Table `arquivoSO_usuario`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `arquivoSO_usuario` (
  `idUsu` INT NOT NULL,
  `idArq` INT NOT NULL,
  PRIMARY KEY (`idUsu`, `idArq`),
  FOREIGN KEY (`idUsu`) REFERENCES `usuario` (`idUsu`),
  FOREIGN KEY (`idArq`) REFERENCES `arquivoSO` (`idArq`)
)
ENGINE = InnoDB;
-- drop table arquivoSO_usuario;

-- -----------------------------------------------------
-- Table `quatidadeDeArquivosSO`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `quantidadeDeArquivosSO` (
  `qtdArq` INT DEFAULT 0 COMMENT 'Tabela a ser atualizada com trigger'
)
ENGINE = InnoDB;
drop table quantidadeDeArquivosSO;
truncate table quantidadeDeArquivosSO;
insert into quantidadeDeArquivosSO(qtdArq) values(0);
SELECT * FROM quantidadeDeArquivosSO;

-- -----------------------------------------------------
-- Table `logsSistema`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `logsSistema` (
  `idlogsSistema` INT NOT NULL AUTO_INCREMENT COMMENT 'Tabela a ser atualizada com trigger',
  `usuario`  varchar(45),
  `datahora` datetime default current_timestamp,
  `operacao` varchar(45),
   PRIMARY KEY (`idlogsSistema`))
ENGINE = InnoDB;

drop table logsSistema;
truncate table logsSistema;
select * from logsSistema;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
