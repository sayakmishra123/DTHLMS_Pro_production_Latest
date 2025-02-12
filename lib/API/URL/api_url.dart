class ClsUrlApi {
  // static const mainurl =
  //     String.fromEnvironment('base_url', defaultValue: 'dthclass.com');

  static const mainurl = "apipro20240709.dthlms.com";

  static const loginEndpoint = '/api/auth/login';
  static const checkUserExitenceBeforeregister =
      '/api/AnonymousDataGet/ExecuteJson/spValidateexistingUser/1'; ////////////
  static const socialMediaIconsApi =
      '/api/AuthDataGet/ExecuteJson/sptblSocialMediaLinks/14';
  static const getInfiniteMarqueeDetailsApi =
      "/api/AuthDataGet/ExecuteJson/spAppApi/48";
  static const getNotificationsDetailsApi =
      "/api/AuthDataGet/ExecuteJson/spAppApi/52";
  static const getIconDataApi = "/api/AuthDataGet/ExecuteJson/spAppApi/49";
  static const signupEndpoint = "/api/auth/studentregister/";
  static const getUserConfirmationTypeEndpoint =
      "/api/auth/getUserConfirmationType";
  static const generateSRCode = "/api/auth/generateSRCode";
  static const generateCodeEndpoint = '/api/auth/generateCode';

  static const studentVideoreviewlink = '/api/auth/studentVideoreview';
  static const resendOtp = '/api/auth/resendOtp';
  static const allpackage = '/api/AuthDataGet/ExecuteJson/sptblPackage/4';
  static const packagedetails =
      "/api/AuthDataGet/ExecuteJson/sptblPackageDetails/2";
  static const studentvideoWatchtime = '/api/auth/studentvideoWatchtime/';

  static const forgetpassword = '/api/auth/forgetPassword/';
  static const resetPassword = '/api/auth/resetPassword/';
  static const studentActivationkey = "/api/AuthDataGet/ExecuteJson/spAppApi/2";
  static const tblpackage = "/api/AuthDataGet/ExecuteJson/spAppApi/5";
  static const logoutapi = '/api/auth/logout';

  static const getFileData = "/api/AuthDataGet/ExecuteJson/spAppApi/6";
  static const getFreePackageFiles = "/api/AuthDataGet/ExecuteJson/spAppApi/3";
  static const getFolderData = "/api/AuthDataGet/ExecuteJson/spAppApi/12";
  static const getPackageData = "/api/AuthDataGet/ExecuteJson/spAppApi/14";
  static const getVideoComponents = "/api/AuthDataGet/ExecuteJson/spAppApi/15";
  static const getMeeting =
      "/api/AuthDataGet/ExecuteJson/sptblEncryptionHistory/15";

  static const getEncryptionKey = '/api/AuthDataGet/ExecuteJson/spAppApi/11';

  static const insertvideoTimeDetails =
      '/api/AuthDataGet/ExecuteJson/spAppApi/13';
  static const uploadVideoiInCloudeUrl = '/api/uploads';
  static const askDoubteQuestion = '/api/AuthDataGet/ExecuteJson/spAppApi/16';
  static const uploadFile = '/api/uploads';
  static const changeProfileDetails = '/api/profile/changeuserdetail/';
  static const getUserImage = "/api/AuthDataGet/ExecuteJson/spAppApi/18";
  static const getHompageBanners = "/api/AuthDataGet/ExecuteJson/spAppApi/20";
  static const backgroundapplicationList =
      "/api/AuthDataGet/ExecuteJson/spAppApi/22";
  static const getMcqData = "/api/AuthDataGet/ExecuteJson/spAppApi/23";
  static const sendMarksToCalculateLeaderboard =
      "/api/AuthDataGet/ExecuteJson/spAppApi/24";
  static const getRankedData = "/api/AuthDataGet/ExecuteJson/spAppApi/25";
  static const sendQuestionAnswerList =
      "/api/AuthDataGet/ExecuteJson/spAppApi/26";
  static const sendAnswerSheedIdList =
      "/api/AuthDataGet/ExecuteJson/spAppApi/29";
  static const premiumPackageList = "/api/AuthDataGet/ExecuteJson/spAppApi/28";
  static const premiumPackageInfo = "/api/AuthDataGet/ExecuteJson/spAppApi/30";
  static const getdeviceloginhistory =
      "/api/AuthDataGet/ExecuteJson/spAppApi/31";

  static const getExamStatus = "/api/AuthDataGet/ExecuteJson/spAppApi/32";

  static const getCountryCode =
      "/api/AnonymousDataGet/ExecuteJson/SPMasterAdminAnonymous/1";
  static const generateCodeForgetPassword = "/api/auth/generateFPCode";

  static const getEmailValidation =
      "/api/AnonymousDataGet/ExecuteJson/spValidateexistingUser/2";

  static const getEncryptionKeyAndId = "";
  static const getTheoryExamHistory =
      "/api/AuthDataGet/ExecuteJson/spAppApi/33";
  static const getuploadAccessKey = "/api/AuthDataGet/ExecuteJson/spAppApi/34";
  static const getTestSerisdata = "/api/AuthDataGet/ExecuteJson/spAppApi/35";
  // static const recheckAnswerSheetRequest="/api/AuthDataGet/ExecuteJson/spAppApi/35";
  static const getExamResultForIndividual =
      "/api/AuthDataGet/ExecuteJson/spAppApi/40";
  static const insertMCQHistory = "/api/AuthDataGet/ExecuteJson/spAppApi/41";
  static const getMCQExamHistory = "/api/AuthDataGet/ExecuteJson/spAppApi/42";
  static const getVideoWatchHistory =
      "/api/AuthDataGet/ExecuteJson/spAppApi/43";
  static const getRankMcqResult = "/api/AuthDataGet/ExecuteJson/spAppApi/44";
  static const getRankMcqResultforIndividual =
      "/api/AuthDataGet/ExecuteJson/spAppApi/45";

  static const checkRankedCompetitionStatus =
      "/api/AuthDataGet/ExecuteJson/spAppApi/46";
  static const answerSheetRecheckRequestForTest =
      "/api/AuthDataGet/ExecuteJson/spAppApi/39";
  static const getanswerSheetUrlOfStudent =
      "/api/AuthDataGet/ExecuteJson/spAppApi/55";
  static const uploadStudentFeedback =
      "/api/AuthDataGet/ExecuteJson/spAppApi/56";

        static const activePackageByStudent =
      "/api/AuthDataGet/ExecuteJson/spAppApi/60";
       static const pausePackageByStudent =
      "/api/AuthDataGet/ExecuteJson/spAppApi/61";


}
