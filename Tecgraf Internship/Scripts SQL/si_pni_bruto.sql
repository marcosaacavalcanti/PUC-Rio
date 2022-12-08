drop table if exists si_pni_2022_01_16;

create table si_pni_2022_01_16 (
	document_id varchar(300) not null,
	paciente_id varchar(300) not null,
	paciente_idade varchar(20) null,
	paciente_dataNascimento varchar(20) null,
	paciente_enumSexoBiologico varchar(5) null,
	paciente_racaCor_codigo varchar(5) null,
	paciente_racaCor_valor varchar(50) null,
	paciente_endereco_coIbgeMunicipio varchar(20) null,
	paciente_endereco_coPais varchar(20) null,
	paciente_endereco_nmMunicipio varchar(100) null,
	paciente_endereco_nmPais varchar(100) null,
	paciente_endereco_uf varchar(7) null,
	paciente_endereco_cep varchar(20) null,
	paciente_nacionalidade_enumNacionalidade varchar(50) null,
	estabelecimento_valor varchar(20) null,
	estabelecimento_razaoSocial varchar(300) null,
	estalecimento_noFantasia varchar(300) null,
	estabelecimento_municipio_codigo varchar(20) null,
	estabelecimento_municipio_nome varchar(100) null,
	estabelecimento_uf varchar(3) null,
	vacina_grupoAtendimento_codigo varchar(50) null,
	vacina_grupoatendimento_nome varchar(300) null,
	vacina_categoria_codigo varchar(20) null,
	vacina_categoria_nome varchar(100) null,
	vacina_lote varchar(200) null,
	vacina_fabricante_nome varchar(100) null,
	vacina_fabricante_referencia varchar(200) null,
	vacina_dataAplicacao varchar(20) null,
	vacina_descricao_dose varchar(100) null,
	vacina_codigo varchar(5) null,
	vacina_nome varchar(150) null,
	sistema_origem varchar(100) null
--	data_importacao_rnds varchar(100) null,
--	id_sistema_origem varchar(50) null,
--	vacina_numdose varchar(5) null

);


copy si_pni_2022_01_16
from 'D:\Databases\SI_PNI\si_pni_full_2022_12_16.csv' WITH NULL AS ''  delimiter ';'
csv header;