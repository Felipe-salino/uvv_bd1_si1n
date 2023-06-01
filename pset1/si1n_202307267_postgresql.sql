--Excluir banco de dados UVV existentes
DROP DATABASE IF EXISTS uvv;

--Excluir usuarios existentes com esse nome
DROP USER IF EXISTS felipe;

--Criar usuario e senha para esse usuario
CREATE USER felipe WITH
CREATEDB
CREATEROLE
INHERIT
ENCRYPTED PASSWORD '1512';

--Criar tabela UVV
CREATE DATABASE uvv WITH
OWNER = 'felipe'
TEMPLATE = 'template0'
ENCODING = 'UTF8'
LC_COLLATE = 'pt_BR.UTF-8'
LC_CTYPE ='pt_BR.UTF-8'
ALLOW_CONNECTIONS ='true';

\c uvv;

--Criando Schema
CREATE SCHEMA IF NOT EXISTS lojas
AUTHORIZATION felipe;
ALTER USER felipe;
SET SEARCH_PATH TO lojas, "&user", public;

-- tabela produtose seus coentarios da tabela
CREATE TABLE produto (
                produto_id NUMERIC(38) NOT NULL,
                nome VARCHAR(255) NOT NULL,
                preco_unitario NUMERIC(10,2),
                detalhes BYTEA,
                imagem BYTEA,
                imagem_mime_type VARCHAR(512),
                imagem_arquivo VARCHAR(512),
                imagem_charset VARCHAR(512),
                imagem_ultima_atualizacao DATE,
                CONSTRAINT produtos PRIMARY KEY (produto_id)
);
COMMENT ON TABLE produto IS 'tabela sobre os produtos da loja';
COMMENT ON COLUMN produto.produto_id IS 'identificação do produto';
COMMENT ON COLUMN produto.nome IS 'nome do produto';
COMMENT ON COLUMN produto.preco_unitario IS 'preço da unidade do produto';
COMMENT ON COLUMN produto.detalhes IS 'detalhes sobre o produto';
COMMENT ON COLUMN produto.imagem IS 'imagem do produto';
COMMENT ON COLUMN produto.imagem_mime_type IS 'identificação da imagem por caracter';
COMMENT ON COLUMN produto.imagem_arquivo IS 'arquivo de imagens';
COMMENT ON COLUMN produto.imagem_charset IS 'codificação da imagem';
COMMENT ON COLUMN produto.imagem_ultima_atualizacao IS 'ultima atualização da imagem';

--tabela loja e seus comentarios
CREATE TABLE loja (
                loja_id NUMERIC(38) NOT NULL,
                nome VARCHAR(255) NOT NULL,
                endereco_web VARCHAR(100),
                endereco_fisicia VARCHAR(512),
                latitude NUMERIC,
                longitude NUMERIC,
                logo BYTEA,
                logo_mime_type VARCHAR(512),
                logo_arquivo VARCHAR(512),
                logo_charset VARCHAR(512),
                logo_ultima_atualizacao DATE,
                CONSTRAINT lojas PRIMARY KEY (loja_id)
);
COMMENT ON TABLE loja IS 'tabela referente as lojas';
COMMENT ON COLUMN loja.loja_id IS 'identificação da loja';
COMMENT ON COLUMN loja.nome IS 'nome do cliente';
COMMENT ON COLUMN loja.endereco_web IS 'endereço da loja virtual';
COMMENT ON COLUMN loja.endereco_fisicia IS 'enderço da loja fisica';
COMMENT ON COLUMN loja.latitude IS 'localização geografica da loja';
COMMENT ON COLUMN loja.longitude IS 'localização geografica da loja';
COMMENT ON COLUMN loja.logo IS 'logo da loja';
COMMENT ON COLUMN loja.logo_mime_type IS 'indentificação da logo por caracter';
COMMENT ON COLUMN loja.logo_arquivo IS 'arquivos das logos';
COMMENT ON COLUMN loja.logo_charset IS 'codificação da logo';
COMMENT ON COLUMN loja.logo_ultima_atualizacao IS 'ultima atualização da logo';

--tabela estoque e seus comentarios
CREATE TABLE estoque (
                estoque_id NUMERIC(38) NOT NULL,
                loja_id NUMERIC(38) NOT NULL,
                produto_id NUMERIC(38) NOT NULL,
                quantidade NUMERIC(38) NOT NULL,
                CONSTRAINT estoques PRIMARY KEY (estoque_id)
);
COMMENT ON TABLE estoque IS 'tabela sobre os estoques';
COMMENT ON COLUMN estoque.estoque_id IS 'identificação do estoque';
COMMENT ON COLUMN estoque.loja_id IS 'identificação da loja';
COMMENT ON COLUMN estoque.produto_id IS 'identificação do produto';
COMMENT ON COLUMN estoque.quantidade IS 'quantidade desse produto no estoque';

--tabela cliente e seus comentarios
CREATE TABLE cliente (
                cliente_id NUMERIC(38) NOT NULL,
                email VARCHAR(255) NOT NULL,
                nome VARCHAR(255) NOT NULL,
                telefone1 VARCHAR(20),
                telefone2 VARCHAR(20),
                telefone3 VARCHAR(20),
                CONSTRAINT clientes PRIMARY KEY (cliente_id)
);
COMMENT ON TABLE cliente IS 'tabela com as informções dos clientes';
COMMENT ON COLUMN cliente.cliente_id IS 'identificação do cliente';
COMMENT ON COLUMN cliente.email IS 'email do cliente';
COMMENT ON COLUMN cliente.nome IS 'nome do cliente';
COMMENT ON COLUMN cliente.telefone1 IS 'telefone do cliente';
COMMENT ON COLUMN cliente.telefone2 IS 'telefone do cliente';
COMMENT ON COLUMN cliente.telefone3 IS 'telefone do cliente';

----tabela envo e seus comentarios
CREATE TABLE envio (
                envio_id NUMERIC(38) NOT NULL,
                loja_id NUMERIC(38) NOT NULL,
                cliente_id NUMERIC(38) NOT NULL,
                endereco_entrega VARCHAR(512) NOT NULL,
                status VARCHAR(15) NOT NULL,
                CONSTRAINT envios PRIMARY KEY (envio_id),
                --CRIAÇÃO DA CHECKS TABELA ENVIOS
                CONSTRAINT ck_envio_status
                CHECK (status IN ('CRIADO' , 'ENVIADO' , 'TRANSITO' , 'ENTREGUE')));

COMMENT ON TABLE envio IS 'tabela referente aos envios';
COMMENT ON COLUMN envio.envio_id IS 'identificação do envio';
COMMENT ON COLUMN envio.loja_id IS 'identificação da loja';
COMMENT ON COLUMN envio.cliente_id IS 'identificação do cliente';
COMMENT ON COLUMN envio.endereco_entrega IS 'endereço de entrega do produto';
COMMENT ON COLUMN envio.status IS 'status sobre o envio do produto';

--tabela pedido e seus comentarios
CREATE TABLE pedido (
                pedido_id NUMERIC(38) NOT NULL,
                data_hora TIMESTAMP NOT NULL,
                cliente_id NUMERIC(38) NOT NULL,
                status VARCHAR(15) NOT NULL,
                loja_id NUMERIC(38) NOT NULL,
                CONSTRAINT pedidos PRIMARY KEY (pedido_id),
                --CRIAÇÃO DA CHECK DOS PEDIDOS
                CONSTRAINT ck_pedido_status
                CHECK (status IN ('CANCELADO' , 'COMPLETO' , 'ABERTO' , 'PAGO' , 'REEMBOLSADO' , 'ENVIADO')));

COMMENT ON TABLE pedido IS 'tabela sobre o pedido do produto';
COMMENT ON COLUMN pedido.pedido_id IS 'identificação do pedido';
COMMENT ON COLUMN pedido.data_hora IS 'data e a hora do pedido';
COMMENT ON COLUMN pedido.cliente_id IS 'identificação do cliente';
COMMENT ON COLUMN pedido.status IS 'status sobre o envio';
COMMENT ON COLUMN pedido.loja_id IS 'identificação da loja que foi feita o pedido';

--tabela pedido_itens e seus comentarios
CREATE TABLE pedidos_item (
                pedido_id NUMERIC(38) NOT NULL,
                produto_id NUMERIC(38) NOT NULL,
                numero_da_linha NUMERIC(38) NOT NULL,
                preco_unitario NUMERIC(10,2) NOT NULL,
                quantidade NUMERIC(38) NOT NULL,
                envio_id NUMERIC(38),
                CONSTRAINT pedidos_itens PRIMARY KEY (pedido_id, produto_id)
);
COMMENT ON TABLE pedidos_item IS 'pedidos dos itens';
COMMENT ON COLUMN pedidos_item.pedido_id IS 'identificação do pedido';
COMMENT ON COLUMN pedidos_item.produto_id IS 'identificação do produto';
COMMENT ON COLUMN pedidos_item.numero_da_linha IS 'numero da linha do produto';
COMMENT ON COLUMN pedidos_item.preco_unitario IS 'preço da unidade do produto';
COMMENT ON COLUMN pedidos_item.quantidade IS 'quantidade desse produto';
COMMENT ON COLUMN pedidos_item.envio_id IS 'identificação do envio';


ALTER TABLE pedidos_item ADD CONSTRAINT produtos_pedidos_itens_fk
FOREIGN KEY (produto_id)
REFERENCES produto (produto_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE estoque ADD CONSTRAINT produtos_estoques_fk
FOREIGN KEY (produto_id)
REFERENCES produto (produto_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE pedido ADD CONSTRAINT lojas_pedidos_fk
FOREIGN KEY (loja_id)
REFERENCES loja (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE estoque ADD CONSTRAINT lojas_estoques_fk
FOREIGN KEY (loja_id)
REFERENCES loja (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE envio ADD CONSTRAINT lojas_envios_fk
FOREIGN KEY (loja_id)
REFERENCES loja (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE pedido ADD CONSTRAINT clientes_pedidos_fk
FOREIGN KEY (cliente_id)
REFERENCES cliente (cliente_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE envio ADD CONSTRAINT clientes_envios_fk
FOREIGN KEY (cliente_id)
REFERENCES cliente (cliente_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE pedidos_item ADD CONSTRAINT envios_pedidos_itens_fk
FOREIGN KEY (envio_id)
REFERENCES envio (envio_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE pedidos_item ADD CONSTRAINT pedidos_pedidos_itens_fk
FOREIGN KEY (pedido_id)
REFERENCES pedido (pedido_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;
