# 💸 OrçaMente

**OrçaMente** é um aplicativo mobile desenvolvido em Flutter com foco em **educação financeira**, permitindo ao usuário **controlar seus gastos**, **definir metas**, **fazer cursos** e até **descobrir seu perfil financeiro** com um quiz interativo. O projeto segue o padrão **MVC**.

---
## 📱 Funcionalidades

### ✅ Funcionalidades já implementadas

- [x] **Tela de Login** (sem autenticação real, apenas navegação)
- [x] **Tela de Cadastro de Usuário**
- [x] **Tela de "Esqueceu a Senha"**
- [x] **Cofrinho virtual** com:
  - Visualização do valor guardado
  - Definição de meta financeira com formatação de moeda
  - Campo para adicionar valores com formatação e feedback via `SnackBar`
- [x] **Quiz de Perfil Financeiro** (Gastador, Poupador ou Investidor)
- [x] **Tela de Extrato**
- [x] **Tela de Cursos** e **Módulos**
- [x] **Gamificação inicial** (protótipo de mini jogo financeiro)
- [x] **Tema claro e escuro** com `CustomTheme`

---

## ☁️ Integração com Firebase

O projeto utiliza o **Firebase** para armazenamento e gerenciamento de dados:

- 🔥 **Firebase Firestore**
  - Armazenamento de despesas por categoria (`essencial`, `lazer`, `outros`)
  - Respostas do quiz financeiro
  - Dados de usuários cadastrados

- 🔐 **Firebase Authentication**
  - Autenticação via e-mail e senha
  - Reset de senha via e-mail

- 📦 Para configurar, crie seu projeto no [Firebase Console](https://console.firebase.google.com), ative Authentication e Firestore, e insira o `google-services.json` no diretório `android/app`.

---

## 🎯 Tecnologias utilizadas

- **Flutter** (SDK principal)
- **Dart** (linguagem de programação)
- **MVC Pattern** (estrutura do projeto)
- **Pacotes principais:**
  - `get_it` – Injeção de dependência
  - `shared_preferences` – Armazenamento local
  - `device_preview` – Preview em múltiplos dispositivos
  - `lucide_icons` – Ícones modernos
  - `flutter_multi_formatter` – Formatação de moeda e números
  - `firebase_core` – Inicialização do Firebase
  - `firebase_auth` – Autenticação de usuários

---

## 🛠️ Como rodar o projeto


1. **Clone o repositório:**

```bash
git clone https://github.com/seu-usuario/orcamente.git
cd orcamente

```

2. **Instale as dependências:**

```bash
flutter pub get
```
3. **Rode o app:**

```bash
flutter run
```
## 📌 Observações

- Este projeto ainda está em desenvolvimento.

- Próximos passos incluem: integração com banco de dados local, autenticação real e integração com agentes de IA para orientar usuários com base no perfil financeiro.

## 👩‍💻 Autor

Projeto desenvolvido por Antônio Pires Felipe.
