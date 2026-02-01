/// Centralized error and user-facing messages
/// All user-facing messages should be defined here for easier i18n in the future
class AppMessages {
  // Private constructor to prevent instantiation
  AppMessages._();

  // ============================================================================
  // AUTHENTICATION MESSAGES
  // ============================================================================

  /// Authentication error messages
  static const String authInvalidCredential = 'Email ou senha inválidos';
  static const String authUserNotFound = 'Usuário não encontrado';
  static const String authWrongPassword = 'Senha incorreta';
  static const String authEmailAlreadyInUse = 'Este email já está cadastrado';
  static const String authWeakPassword =
      'A senha deve ter pelo menos 6 caracteres';
  static const String authNetworkError = 'Sem conexão com a internet';
  static const String authUnknownError = 'Erro ao autenticar. Tente novamente.';
  static const String authUserDisabled = 'Esta conta foi desativada';
  static const String authTooManyRequests =
      'Muitas tentativas. Aguarde alguns minutos.';
  static const String authOperationNotAllowed = 'Operação não permitida';
  static const String authInvalidEmail = 'Email inválido';

  /// Authentication success messages
  static const String authLoginSuccess = 'Login realizado com sucesso!';
  static const String authRegisterSuccess = 'Cadastro realizado com sucesso!';
  static const String authLogoutSuccess = 'Logout realizado com sucesso';
  static const String authPasswordResetSent =
      'Link de recuperação enviado para seu e-mail';

  /// Authentication form validation messages
  static const String authEmailRequired = 'E-mail obrigatório';
  static const String authEmailInvalid = 'Digite um e-mail válido';
  static const String authPasswordRequired = 'Senha obrigatória';
  static const String authPasswordTooShort =
      'A senha deve ter pelo menos 6 caracteres';
  static const String authPasswordMismatch = 'As senhas não coincidem';
  static const String authNameRequired = 'Nome obrigatório';
  static const String authNameTooShort =
      'Nome deve ter pelo menos 2 caracteres';
  static const String authPhoneRequired = 'Telefone obrigatório';
  static const String authPhoneInvalid = 'Telefone inválido';

  // ============================================================================
  // FIRESTORE MESSAGES
  // ============================================================================

  /// Firestore error messages
  static const String firestorePermissionDenied =
      'Sem permissão para acessar os dados';
  static const String firestoreNotFound = 'Dados não encontrados';
  static const String firestoreAlreadyExists = 'Dados já existem';
  static const String firestoreUnavailable =
      'Serviço temporariamente indisponível';
  static const String firestoreUnknownError =
      'Erro ao acessar dados. Tente novamente.';
  static const String firestoreNetworkError =
      'Erro de conexão. Verifique sua internet.';

  /// Firestore success messages
  static const String firestoreSaveSuccess = 'Dados salvos com sucesso!';
  static const String firestoreUpdateSuccess = 'Dados atualizados com sucesso!';
  static const String firestoreDeleteSuccess = 'Dados removidos com sucesso!';

  // ============================================================================
  // EXPENSE MESSAGES
  // ============================================================================

  /// Expense error messages
  static const String expenseLoadError = 'Erro ao carregar despesas';
  static const String expenseAddError = 'Erro ao adicionar despesa';
  static const String expenseUpdateError = 'Erro ao atualizar despesa';
  static const String expenseDeleteError = 'Erro ao remover despesa';
  static const String expenseInvalidData = 'Dados da despesa inválidos';

  /// Expense success messages
  static const String expenseAdded = 'Despesa adicionada com sucesso!';
  static const String expenseUpdated = 'Despesa atualizada com sucesso!';
  static const String expenseDeleted = 'Despesa removida';

  /// Expense validation messages
  static const String expenseDescriptionRequired = 'Descrição obrigatória';
  static const String expenseDescriptionTooLong =
      'Descrição muito longa (máx. 200 caracteres)';
  static const String expenseValueRequired = 'Valor obrigatório';
  static const String expenseValueInvalid = 'Valor inválido';
  static const String expenseValueTooLow = 'Valor deve ser maior que zero';
  static const String expenseValueTooHigh = 'Valor muito alto';
  static const String expenseCategoryRequired = 'Categoria obrigatória';
  static const String expenseCategoryInvalid = 'Categoria inválida';
  static const String expenseDateRequired = 'Data obrigatória';
  static const String expenseDateInvalid = 'Data inválida';

  /// Expense UI messages
  static const String expenseEmptyList = 'Nenhum gasto registrado';
  static const String expenseEmptySearch = 'Nenhum resultado encontrado';
  static const String expenseUndoAction = 'DESFAZER';

  // ============================================================================
  // PIGGY BANK MESSAGES
  // ============================================================================

  /// PiggyBank error messages
  static const String piggyBankLoadError = 'Erro ao carregar cofrinho';
  static const String piggyBankSaveError = 'Erro ao salvar cofrinho';
  static const String piggyBankUpdateError = 'Erro ao atualizar cofrinho';
  static const String piggyBankMigrationError =
      'Erro ao migrar dados do cofrinho';

  /// PiggyBank success messages
  static const String piggyBankSaved = 'Cofrinho salvo com sucesso!';
  static const String piggyBankUpdated = 'Cofrinho atualizado com sucesso!';
  static const String piggyBankGoalReached = 'Parabéns! Você atingiu sua meta!';
  static const String piggyBankDepositSuccess =
      'Depósito realizado com sucesso!';
  static const String piggyBankWithdrawSuccess = 'Saque realizado com sucesso!';

  /// PiggyBank validation messages
  static const String piggyBankNameRequired = 'Nome do cofrinho obrigatório';
  static const String piggyBankGoalRequired = 'Meta obrigatória';
  static const String piggyBankGoalInvalid = 'Meta inválida';
  static const String piggyBankGoalTooLow = 'Meta deve ser maior que zero';
  static const String piggyBankAmountInvalid = 'Valor inválido';
  static const String piggyBankInsufficientFunds = 'Saldo insuficiente';

  // ============================================================================
  // USER MESSAGES
  // ============================================================================

  /// User error messages
  static const String userLoadError = 'Erro ao carregar dados do usuário';
  static const String userUpdateError = 'Erro ao atualizar perfil';
  static const String userSaveError = 'Erro ao salvar dados';

  /// User success messages
  static const String userProfileUpdated = 'Perfil atualizado com sucesso!';
  static const String userDataSaved = 'Dados salvos com sucesso!';

  // ============================================================================
  // QUIZ MESSAGES
  // ============================================================================

  /// Quiz error messages
  static const String quizLoadError = 'Erro ao carregar quiz';
  static const String quizSaveError = 'Erro ao salvar respostas';

  /// Quiz success messages
  static const String quizCompleted = 'Quiz concluído com sucesso!';
  static const String quizAnswersSaved = 'Respostas salvas com sucesso!';

  // ============================================================================
  // NETWORK MESSAGES
  // ============================================================================

  /// Network error messages
  static const String networkNoConnection = 'Sem conexão com a internet';
  static const String networkTimeout = 'Tempo de conexão esgotado';
  static const String networkUnknownError = 'Erro de conexão. Tente novamente.';
  static const String networkSlowConnection = 'Conexão lenta detectada';

  /// Network action messages
  static const String networkRetry = 'Tentar novamente';
  static const String networkCheckConnection = 'Verifique sua conexão';

  // ============================================================================
  // VALIDATION MESSAGES (GENERAL)
  // ============================================================================

  /// General validation messages
  static const String validationRequired = 'Campo obrigatório';
  static const String validationInvalid = 'Valor inválido';
  static const String validationTooShort = 'Muito curto';
  static const String validationTooLong = 'Muito longo';
  static const String validationNumericOnly = 'Apenas números';
  static const String validationAlphaOnly = 'Apenas letras';

  /// Currency validation
  static const String currencyInvalid = 'Valor monetário inválido';
  static const String currencyFormat = 'Use o formato: 00,00';

  // ============================================================================
  // UI MESSAGES
  // ============================================================================

  /// Loading messages
  static const String loadingDefault = 'Carregando...';
  static const String loadingAuth = 'Autenticando...';
  static const String loadingData = 'Carregando dados...';
  static const String loadingSaving = 'Salvando...';
  static const String loadingDeleting = 'Removendo...';
  static const String loadingUpdating = 'Atualizando...';
  static const String loadingSending = 'Enviando...';

  /// Action messages
  static const String actionSave = 'Salvar';
  static const String actionCancel = 'Cancelar';
  static const String actionDelete = 'Excluir';
  static const String actionEdit = 'Editar';
  static const String actionAdd = 'Adicionar';
  static const String actionRetry = 'Tentar novamente';
  static const String actionClose = 'Fechar';
  static const String actionConfirm = 'Confirmar';
  static const String actionContinue = 'Continuar';
  static const String actionBack = 'Voltar';

  /// Confirmation messages
  static const String confirmDelete = 'Tem certeza que deseja excluir?';
  static const String confirmLogout = 'Tem certeza que deseja sair?';
  static const String confirmCancel = 'Tem certeza que deseja cancelar?';

  /// Empty state messages
  static const String emptyListDefault = 'Lista vazia';
  static const String emptySearchResults = 'Nenhum resultado encontrado';
  static const String emptyData = 'Nenhum dado disponível';

  // ============================================================================
  // SUCCESS MESSAGES (GENERAL)
  // ============================================================================

  /// Generic success messages
  static const String successDefault = 'Operação realizada com sucesso!';
  static const String successSaved = 'Salvo com sucesso!';
  static const String successUpdated = 'Atualizado com sucesso!';
  static const String successDeleted = 'Removido com sucesso!';
  static const String successSent = 'Enviado com sucesso!';

  // ============================================================================
  // ERROR MESSAGES (GENERAL)
  // ============================================================================

  /// Generic error messages
  static const String errorDefault = 'Ops! Algo deu errado';
  static const String errorUnknown = 'Erro desconhecido. Tente novamente.';
  static const String errorTryAgain = 'Erro ao processar. Tente novamente.';
  static const String errorContactSupport =
      'Se o erro persistir, entre em contato com o suporte.';

  // ============================================================================
  // HELPER METHODS
  // ============================================================================

  /// Maps Firebase Auth error codes to user-friendly messages
  static String getAuthErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'invalid-credential':
        return authInvalidCredential;
      case 'user-not-found':
        return authUserNotFound;
      case 'wrong-password':
        return authWrongPassword;
      case 'email-already-in-use':
        return authEmailAlreadyInUse;
      case 'weak-password':
        return authWeakPassword;
      case 'network-request-failed':
        return authNetworkError;
      case 'user-disabled':
        return authUserDisabled;
      case 'too-many-requests':
        return authTooManyRequests;
      case 'operation-not-allowed':
        return authOperationNotAllowed;
      case 'invalid-email':
        return authInvalidEmail;
      default:
        return authUnknownError;
    }
  }

  /// Maps Firestore error codes to user-friendly messages
  static String getFirestoreErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'permission-denied':
        return firestorePermissionDenied;
      case 'not-found':
        return firestoreNotFound;
      case 'already-exists':
        return firestoreAlreadyExists;
      case 'unavailable':
        return firestoreUnavailable;
      case 'network-request-failed':
        return firestoreNetworkError;
      default:
        return firestoreUnknownError;
    }
  }

  /// Returns appropriate loading message based on operation
  static String getLoadingMessage(String operation) {
    switch (operation) {
      case 'auth':
        return loadingAuth;
      case 'save':
        return loadingSaving;
      case 'delete':
        return loadingDeleting;
      case 'update':
        return loadingUpdating;
      case 'send':
        return loadingSending;
      default:
        return loadingData;
    }
  }
}
