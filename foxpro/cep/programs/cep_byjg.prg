_SCREEN.AutoCenter = .T.
_SCREEN.WindowState = 2
_SCREEN.Visible = .T.

LOCAL loWSByjg as "MSSOAP.SoapClient30"
loWSByjg = CREATEOBJECT("MSSOAP.SoapClient30")

WAIT "Conectando..." WINDOW NOWAIT NOCLEAR
loWSByjg.MSSoapInit("http://www.byjg.com.br/site/webservice.php/ws/cep?WSDL", "CEPService", "CEPServicePort")
WAIT CLEAR

IF EMPTY(loWSByjg.FaultString)
	MESSAGEBOX("Versão " + loWSByjg.obterVersao() + ".", 48, "WEB Service BYJG - Consulta de Cep")
	
	IF MESSAGEBOX("Obter logradouro?", 36, "Consuta de Logradouro") = 6
		LOCAL lcCep
		lcCep = CHRTRAN(ALLTRIM(INPUTBOX("Informe o cep do logradouro que você procura.", "Obter Logradouro", "", 0, "", "")), "-", "")
		lcCep = IIF(EMPTY(lcCep), "", PADR(lcCep, 8, "0"))
		
		IF EMPTY(lcCep)
			MESSAGEBOX("Não foi possível efetuar a consulta. É necessário informar o cep do logradouro.", 16, "Parada Crítica")
		ELSE
			MESSAGEBOX(loWSByjg.obterLogradouro(lcCep), 48, "Resultado")
		ENDIF
	ENDIF

	IF MESSAGEBOX("Obter cep?", 36, "Consuta de Cep") = 6
		LOCAL lcLogradouro, lcLocalidade, lcUF
		lcLogradouro = ALLTRIM(INPUTBOX("Digite o nome do logradouro.", "Consutla de Cep", "", 0, "", ""))

		IF EMPTY(lcLogradouro)
			MESSAGEBOX("Não foi possível efetuar a consulta. É necessário informar o nome do logradouro.", 16, "Parada Crítica")
		ELSE
			lcLocalidade = ALLTRIM(INPUTBOX("Digite o nome da localidade.", "Consutla de Cep", "", 0, "", ""))

			IF EMPTY(lcLocalidade)
				MESSAGEBOX("Não foi possível efetuar a consulta. É necessário informar o nome da Localidade.", 16, "Parada Crítica")
			ELSE
				lcUF = ALLTRIM(INPUTBOX("Digite a sigla da UF.", "Consutla de Cep", "", 0, "", ""))

				IF EMPTY(lcUF)
					MESSAGEBOX("Não foi possível efetuar a consulta. É necessário informar a sigla da UF.", 16, "Parada Crítica")
				ELSE
					MESSAGEBOX(loWSByjg.obterCep(lcLogradouro, lcLocalidade, lcUF), 48, "Resultado")
				ENDIF
			ENDIF
		ENDIF
	ENDIF

ELSE
	MESSAGEBOX("Falha ao tentar criar conexão com o WEB SERVICE." + loWSByjg.FaultString, 16, "Erro")
ENDIF