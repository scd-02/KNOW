import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:convert'; // to convert data to json format
// import 'package:http/http.dart' as http;
// import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:know/components/commonWidgets/app_bar.dart';
import 'package:telephony/telephony.dart';
// import 'package:permission_handler/permission_handler.dart';

class BillsMessage extends StatefulWidget {
  const BillsMessage({Key? key}) : super(key: key);

  @override
  State<BillsMessage> createState() => _BillsMessageState();
}

class _BillsMessageState extends State<BillsMessage> {
  // final SmsQuery _query = SmsQuery();
  final Telephony telephony = Telephony.instance;
  List<String?> _creditedMessages = [];
  List<String?> _debitedMessages = [];
  DateTime? _startDate;
  DateTime? _endDate;
  double totalCreditedAmount = 0.0;
  double totalDebitedAmount = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(title: 'Bills Messages'),
      ),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _DateFilter(
              onStartDateSelected: (date) => _startDate = date,
              onEndDateSelected: (date) => _endDate = date,
            ),
            const SizedBox(height: 10),
            _MessageSection(title: 'Credited', messages: _creditedMessages),
            const SizedBox(height: 10),
            _MessageSection(title: 'Debited', messages: _debitedMessages),
            const SizedBox(height: 10),
            _TotalAmountSection(
              totalCreditedAmount: totalCreditedAmount,
              totalDebitedAmount: totalDebitedAmount,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // var permission = await Permission.sms.request();
          bool? permission = await telephony.requestPhoneAndSmsPermissions;
          if (permission == true) {
            if (_startDate == null || _endDate == null) {
              // Show an error message or handle the case where dates are not selected
              return;
            }

            // final messages = await _query.querySms(kinds: [SmsQueryKind.inbox]);

            List<String?> creditedMessages = [];
            List<String?> debitedMessages = [];
            double creditedAmount = 0.0;
            double debitedAmount = 0.0;

            Set<String> bankNameList = {
              'ABBNK',
              'ACBLBK',
              'SATBNK',
              'ADRBNK',
              'APSSBN',
              'AGRABK',
              'ZSAGRA',
              '171717',
              '177177',
              '650017',
              '650137',
              'AIRBNK',
              'AIRBSE',
              'AIRBSI',
              'AKHAND',
              'TADCBK',
              'ALVIBK',
              'ALBANK',
              'ALMABK',
              'ALMORA',
              'APCBNK',
              'AEITSM',
              'AMEXBK',
              'AMEXBP',
              'AMEXBT',
              'AMEXEP',
              'AMEXIN',
              'AMEXSR',
              'AXPOPS',
              'AXPVPN',
              'EXCLCK',
              'MIAMEX',
              'MYAMEX',
              'ANSBNK',
              'ANDBNK',
              'APGVBK',
              'APGBBK',
              'APGBHO',
              'APGBIT',
              'APGBNK',
              'APGECM',
              'APHOAT',
              'HORRMD',
              'ROATPM',
              'ROKDPA',
              'ROKDRI',
              'ROKRNL',
              'RONDYL',
              'RONELR',
              'ROONGL',
              'RORJPA',
              'APNABK',
              'APNAPR',
              'APNATR',
              'ACBLHO',
              'APXBNK',
              'APRBBK',
              'APRBHO',
              'ASCBNK',
              'ASSBNK',
              'ASSOBK',
              '120012',
              '121200',
              '180012',
              '181200',
              '181212',
              'AUBANK',
              'AUBMSG',
              'AUBSMS',
              'AUDOST',
              'AUITSM',
              'AXISB',
              'AXISBK',
              'AXISHR',
              'AXISIN',
              'AXISMR',
              'AXISPR',
              'AXISSR',
              'AXSFI',
              'AXSFIN',
              'FCHRGE',
              'LICCRD',
              'SMGPAY',
              'BASBNK',
              'BNSBL',
              'BUCBKL',
              'BUCBRJ',
              '154321',
              'BDNSMS',
              'BNDNBK',
              'BNDNHL',
              'BOBBIZ',
              'BOBBNK',
              'BOBCMS',
              'BOBCRM',
              'BOBFRM',
              'BOBMSG',
              'BOBOTP',
              'BOBRAJ',
              'BOBSCE',
              'BOBSCF',
              'BOBSMS',
              'BOBTRE',
              'BOBTXN',
              'BOBUPG',
              'BOBUPI',
              '126995',
              'BOIBAL',
              'BOIIND',
              'BOIINT',
              'BOIJGB',
              'BOILON',
              'BOINJG',
              'BOIREM',
              'BOISAF',
              'BOISME',
              'BOIVKG',
              'MAHABK',
              'BOMSCT',
              'BANKIT',
              'BRKGBD',
              'BRKGBM',
              'BRKGBS',
              'BRKGBX',
              'BUPGBB',
              'BUPGBM',
              'BUPGBX',
              'BASODA',
              'BWRUCB',
              'BDCCBK',
              'BHAGNI',
              'BHGINI',
              'BNSBKL',
              'BHUBNK',
              'BURBAN',
              'BRAMHA',
              'BUCBLB',
              '110111',
              'CAANBK',
              'CANBNK',
              'CANRRB',
              'CANRWD',
              'CANMNY',
              'CBSLTD',
              '111540',
              'CHOINS',
              'CSFBNK',
              'CBIOTP',
              'CENTBK',
              'CGGBNK',
              'CHADCC',
              'CHAMBK',
              'CSBANK',
              'CSBN',
              'CSBNKN',
              'CCBANK',
              'CHVRBK',
              'CGBBBK',
              'CRGBAD',
              'CGAPBK',
              'CHSCBK',
              'CSCBNK',
              '152484',
              'CITI',
              'CITIBA',
              'CITIBK',
              'CITIBN',
              'CCOBNK',
              'CTZENS',
              '172586',
              'CUCBNK',
              '111904',
              'CUBANK',
              'CUBFST',
              'CUBLTD',
              'CUBOTP',
              'CUBSMS',
              'CUBUPI',
              'CLABBK',
              'COSTAL',
              'SAINIK',
              'COMCBL',
              'CCBLTD',
              'CORPBK',
              'CSBBNK',
              'DGLCBK',
              'DGBSMS',
              'MGBSMS',
              'JAOLIB',
              'DUCBDA',
              'DBSBNK',
              '130000',
              '130012',
              '143242',
              '150000',
              '188888',
              '190000',
              '199199',
              'DCBANK',
              'DCBBNK',
              'DCBDCB',
              'DEEBNK',
              'DEENBK',
              'DNSBNK',
              'BKDENA',
              'DENABK',
              'DGGBNK',
              'DEOBNK',
              'DBALRT',
              'DEUTBK',
              'DUCOBK',
              '113000',
              'DHANBK',
              'DDCCBK',
              'DSBANK',
              'DSUCBK',
              'TDANCB',
              'DUNDCB',
              'DOHABK',
              '151234',
              'DOMBNK',
              'AJUSBJ',
              'JUSBNK',
              'DACBNK',
              'DMNSBK',
              '101979',
              'EDBANK',
              '115551',
              '155551',
              'EQBANK',
              'EQUTAS',
              'EQUTAT',
              'EQUTAX',
              'EASFBT',
              'ESAFIT',
              'ESAFOT',
              'ESAFPB',
              'ESAFPR',
              'ESAFSF',
              'ESAFTR',
              'ESFUAT',
              'EXIMBK',
              'FDBOTP',
              'FEDFIN',
              '181818',
              'FEDADV',
              'FEDBNK',
              'FEDOTP',
              '107750',
              'FNCARE',
              'FGUCBK',
              'FNGWBK',
              'FINOBK',
              'FINOHR',
              'FINOIN',
              'FINOPB',
              'GSBANK',
              'GVNSBL',
              'GNSBKL',
              '106486',
              '159159',
              'GNDDCC',
              '151892',
              '192518',
              'GPPJSB',
              'GPPSBL',
              'GSSBNK',
              'AMBUJA',
              'GUJAMB',
              'GCBBNK',
              'HPSBNK',
              'HDCCBK',
              '146587',
              'DPCSDX',
              'EBTALT',
              'HDFCAL',
              'HDFCBA',
              'HDFCBK',
              'HDFCBN',
              'HDFCCC',
              'HDFCDC',
              'HDFCFD',
              'HDFCGC',
              'HDFCHI',
              'HDFCHL',
              'HDFCIT',
              'HDFCLI',
              'HDFCPL',
              'HDFCRD',
              'HDFCSD',
              'HDFCSE',
              'HDFCUN',
              'HDFSET',
              'HDFTST',
              'HRHDFC',
              'MIMTMX',
              'PAYZAP',
              'UNIXCE',
              'HPGSMS',
              'HNSBNK',
              'HSBANK',
              'HSBLBK',
              'HSBNKW',
              '142421',
              '142424',
              'ICBANK',
              'ICIBNK',
              'ICICBK',
              'ICICIB',
              'ICICIH',
              'ICICIK',
              'ICICIL',
              'ICICTC',
              'ICIEMP',
              'ICIOTP',
              'ISECLD',
              'ISRVCE',
              '111444',
              'IDBIBK',
              'IDBIDL',
              '111101',
              '111102',
              '111103',
              '111104',
              '111105',
              '111106',
              '111107',
              '111108',
              '111109',
              'IDFCBK',
              'IDFCCM',
              'IDFCFB',
              'IDFCFZ',
              'IDFCIT',
              'IDFCTS',
              'IDFCZ',
              'IDFSIT',
              'IPBCOM',
              'IPBKYC',
              'IPBMSG',
              'IPBOFR',
              'IPBOTP',
              'IPBSEC',
              'MYIPPB',
              'INBUPI',
              'INDBNK',
              'IOBANK',
              'IOBATM',
              'IOBBNK',
              'IOBBQR',
              'IOBCHN',
              'IOBHRD',
              'IOBJLS',
              'IOBMKT',
              'IOBOTP',
              'IMSBNK',
              '116077',
              'IPSBNK',
              'IPSHOI',
              'IPSHOT',
              'IPCBBK',
              'IPCBNK',
              'ISBANK',
              '126666',
              '127777',
              'INDUSA',
              'INDUSB',
              'INDUSO',
              'INTBNK',
              'ITCBBK',
              'ITCBNK',
              'GRAMEN',
              'JGRAMN',
              'JKGRAM',
              'JKGRMN',
              'JKGRNB',
              'JPNBNK',
              'JALAUN',
              '111979',
              'JJSBNK',
              'JMCBNK',
              'JALORE',
              'JLRNSB',
              'JANABK',
              'JANATR',
              'JANATX',
              '151974',
              'JKSBLM',
              'JNJCBL',
              'JNSEVA',
              'JANSVA',
              'JSBGON',
              'JSBLHO',
              'JSBANK',
              'JSBLPN',
              'JSBLBK',
              'JANTHA',
              'JSCBKL',
              'JUCBNK',
              'JNSBBM',
              'TJNSBK',
              '142019',
              'JRGBNK',
              'JMSBLP',
              'JMSBNK',
              'DURGBK',
              'JSKABK',
              'JSKBBG',
              'CCBBTL',
              'JSKBCP',
              'JSKBDA',
              'CCBDWS',
              'DHARBK',
              'DHARCB',
              'CCBGWL',
              'JSKBJP',
              'JSKJBK',
              'CCBKNW',
              'DCBMDL',
              'JSKBMS',
              'JSKBRS',
              'JSKBBK',
              'JSKBRT',
              'CBREWA',
              'CCBSTN',
              'CCBSHR',
              'CCBSNI',
              'JSKBSJ',
              'CCBSDH',
              'CCBTKG',
              'JSKBUJ',
              'CCBDTA',
              'CBGUNA',
              'CCBCHW',
              'CHHIBK',
              'JSKBHB',
              'CCBKGN',
              'CCBMOR',
              'CCBSGR',
              'JSKBVI',
              'VIDBBK',
              'JSKBJH',
              'JSKBNP',
              'CCBRJG',
              'JSBRYP',
              'CCBSVP',
              'JSKBSD',
              'JIVAJI',
              'JCCBNK',
              'JCOMBK',
              'JKBFSL',
              'JNSBJU',
              'JNSBKL',
              'JCCB',
              'KCRBNK',
              'KAIJSB',
              'KPMCCB',
              'KMNBNK',
              '20001',
              '111611',
              '114411',
              '116611',
              'KAGBNK',
              'KVGBBK',
              'KVGBNK',
              'KVGECM',
              'KUCBBK',
              'KUBANK',
              '113311',
              'KGBANK',
              'KSBLBK',
              '100075',
              'KMCBK',
              'KDCCBL',
              'KOTABK',
              'MDKNSB',
              '100811',
              '111000',
              '111888',
              '189766',
              'KBANKT',
              'KOTAKB',
              'KOTAKP',
              'KTKREM',
              'KOTSBN',
              'KOYANA',
              'KRUSHI',
              'KBSBBK',
              'KBSBNK',
              'KMCBLT',
              '118467',
              'KNSBKN',
              'KUNSBB',
              'KUNSUB',
              'LMPUCB',
              'LALABK',
              'MPAPEX',
              'MPRSBK',
              'MNBANK',
              'MGBBNK',
              'MFDUBK',
              '180797',
              'MCUBLH',
              'MDCBKL',
              'MDCBNK',
              'MSBLPN',
              'MUCBLP',
              'MUCBNP',
              'MCNBBK',
              'MAKBNK',
              'MIECBL',
              'MPSCBK',
              'MCOBNK',
              'MCUBNK',
              'MDMSBK',
              'MMSBNK',
              'MANSBK',
              'MCBATM',
              'MCBLTD',
              'MCBOTP',
              'MCBTRN',
              'MPSSBK',
              'MPSSBN',
              'MARSCB',
              'MEGRRB',
              'MGRBBK',
              'MRBBBK',
              'MZBANK',
              'MZBBBK',
              'MSCBNK',
              'MLTBNK',
              'DCBMBD',
              'MORADA',
              '158412',
              'MDLUCB',
              'MUBANK',
              'BRIMPS',
              'CDSAFE',
              'ECOMPW',
              'MBIMPS',
              'UPIPWD',
              'NSCBAK',
              'NSBETW',
              'NVSHUP',
              'NSBANK',
              'NSBNKN',
              'NABARD',
              '140285',
              'TNJCBL',
              'NICBNK',
              'NCBLBK',
              'NISBNK',
              '111555',
              'NSDLCD',
              'NSDLPB',
              'NSDLRM',
              'NUTANB',
              'OSCBNK',
              '140601',
              'OBCBNK',
              'OBCCBS',
              'OBCINB',
              'OBCMBK',
              'OBCOLS',
              'OBCOTP',
              'OBCSMS',
              'OBCSVC',
              'OBCTXN',
              'OBCUPI',
              'PNNSBL',
              'PUBANK',
              'PUCBNK',
              'PALUSB',
              'PBGBBN',
              'PBGKOL',
              'PBGMPB',
              'PATANB',
              'PNSBNK',
              'PATSCB',
              'PSCBNK',
              'PAYTMB',
              'PCBDLK',
              'PMTYBK',
              'PITDCC',
              'PITOBK',
              'POUCBK',
              'PCUBNK',
              'PMRYBK',
              'BKPNSB',
              'PNSBKB',
              'PCCBNK',
              'PMNSBM',
              'PSBLTD',
              'PUPGBK',
              'PCOBNK',
              'PRIMEB',
              'PRYBNK',
              'PRIBNK',
              'PCSBNK',
              'PPCBNK',
              '130013',
              'PMCBNK',
              'PSBANK',
              'PGBSMS',
              'PNBACS',
              'PNBCCD',
              'PNBCRD',
              'PNBCRM',
              'PNBDBD',
              'PNBHRD',
              'PNBJNK',
              'PNBLKO',
              'PNBMKT',
              'PNBOTP',
              'PNBRTS',
              'PNBSMS',
              'PNBTBD',
              'PURBNK',
              'PUBBNK',
              'PUBLTD',
              'PUCBLL',
              'PUCBLP',
              'PUSBNK',
              'RACBNK',
              'RAJABK',
              'RUBANK',
              '123323',
              'RSBLPT',
              'RSSBBK',
              'RMGBBK',
              'RNSBNK',
              '151053',
              'RNBASB',
              'RNBCRM',
              'RNBUPI',
              'RNSBAL',
              'RNSBBC',
              'RNSBKT',
              'RNSBLD',
              'RNSBLT',
              'RNSBMB',
              'RNSBMF',
              'RMCBNK',
              'TRMUCB',
              'RPCOBL',
              'BZRCMB',
              'RCMSBN',
              'RCBRNG',
              'RCOBKL',
              'RAVISC',
              '120011',
              '121111',
              '121314',
              '130001',
              '130011',
              '131415',
              '140001',
              '140011',
              '150001',
              '160001',
              'FASTDV',
              'RATNAK',
              'RBLBBB',
              'RBLBNK',
              'RBLCCC',
              'RBLCRD',
              'RBLHRD',
              'RBLINF',
              'RBLKYC',
              'RBLOFR',
              'RBLOSR',
              'RBLPIL',
              'RBLPLN',
              'RBLSSU',
              'RBLTEC',
              'RBLVPN',
              'RBLWCM',
              'SPRCRD',
              'SPROFR',
              'CMSRBI',
              'RBISAY',
              'RUKBNK',
              'SUSSBN',
              'SADHNA',
              'SSBPUN',
              'SSBNAG',
              'SBTABK',
              'SAIBNK',
              'SNSBMS',
              'SSBNBL',
              'SBLSOL',
              'SSBMJA',
              'SAMBNK',
              'SAMSAH',
              'SSBKLP',
              '132132',
              'SANDUR',
              'SANMTI',
              'SMSBNK',
              'SNCOBL',
              'SSNSBK',
              'SSNSBM',
              'SVBANK',
              'SMCBNK',
              'SHGSMS',
              'SARNSB',
              'SNBHMT',
              'SGBBNK',
              'SGBBTI',
              'SRGBBK',
              'SWMUCB',
              'SBERIN',
              'SBMBNK',
              'SBMIND',
              'SMPBNK',
              'SNSBLS',
              'SSBANK',
              'SSBMAN',
              'SCUBLT',
              'SHBIND',
              'SMCBLT',
              'SHIVBK',
              'SBHART',
              'BNSBNK',
              'CNBANK',
              'DHRTBK',
              'SDCOBK',
              'KNBOTP',
              'OTPSKN',
              'SKNSBL',
              'SLMSBL',
              'MCBNSK',
              'SMNBNK',
              'SPNSBK',
              'PCBANK',
              'SKNSBK',
              'SAVLIP',
              'STNSBL',
              'VSBANK',
              'ADINBK',
              'SACBNK',
              'BASAVA',
              'BSBLTD',
              'SCSBNK',
              'SHAHUB',
              'SGMUCB',
              'JSBLHG',
              'SHSBLH',
              'SJSBLH',
              'MHAVIR',
              'SMUCBS',
              'SSSSBK',
              'YASHBK',
              'GRBANK',
              'SRKCOB',
              'MALOJI',
              'MSBLTD',
              'SUBANK',
              'SUCNAG',
              'SNSBNK',
              'SIKSBK',
              'SIDBIB',
              'SONBNK',
              'SMSSBK',
              '180597',
              'SBMCB',
              'SBMCBK',
              'SRIBNK',
              'SSSBKN',
              'SSSBNB',
              'SSSBNK',
              'FROMSC',
              'SCBANK',
              '141516',
              'ACEPLC',
              'AGMITS',
              'ATMMON',
              'ATMMVS',
              'ATMSBI',
              'ATMSMS',
              'ATMTAD',
              'CBSSBI',
              'CCCDEL',
              'CCHRIR',
              'CCONLN',
              'CCPCAH',
              'CCPCCN',
              'CCRSBI',
              'CFOBAN',
              'CMPHYD',
              'CSDSBI',
              'CTDSBI',
              'CTMUGM',
              'CVELUC',
              'DBPSBI',
              'DGTBNK',
              'DUNICA',
              'EDSADM',
              'FIDSBI',
              'FMCLUC',
              'FSLOCT',
              'GCCSBI',
              'GRCSBG',
              'GRCSBI',
              'GSCLOC',
              'HRMSCC',
              'IAPPRV',
              'ICMTRG',
              'IMAHYD',
              'ISDSBI',
              'ITCOMP',
              'ITRISK',
              'ITRSNC',
              'ITSDEL',
              'ITSLHO',
              'KHLADM',
              'LCTSCS',
              'LHOABU',
              'LHOBAN',
              'LHOGMI',
              'LHOKOL',
              'LHOPAT',
              'MABHYD',
              'MISDEP',
              'PIMSBI',
              'PPGDEP',
              'PVIJAY',
              'RBOPEN',
              'RMMBNR',
              'RMRBLY',
              'SAMLMS',
              'SBBJNB',
              'SBCDRE',
              'SBCWMS',
              'SBDBTL',
              'SBDCOG',
              'SBECOM',
              'SBEPAY',
              'SBEREG',
              'SBERMS',
              'SBFIAH',
              'SBFIMF',
              'SBGALR',
              'SBGITC',
              'SBGLMS',
              'SBGMBS',
              'SBGPPC',
              'SBHIGH',
              'SBHINB',
              'SBHRMS',
              'SBIABD',
              'SBIABU',
              'SBIACS',
              'SBIADS',
              'SBIAHM',
              'SBIAND',
              'SBIAOR',
              'SBIAPP',
              'SBIATM',
              'SBIATT',
              'SBIAVS',
              'SBIBAN',
              'SBIBHO',
              'SBIBHU',
              'SBIBNK',
              'SBIBOG',
              'SBIBSC',
              'NWMIND',
              'SBIBTU',
              'SBICAA',
              'SBICAR',
              'SBICBG',
              'SBICDC',
              'SBICDS',
              'SBICHA',
              'SBICHD',
              'SBICHE',
              'SBICMD',
              'SBICMP',
              'SBICMS',
              'SBICON',
              'SBICOS',
              'SBICPA',
              'SBICPC',
              'SBICPP',
              'SBICRS',
              'SBICVC',
              'SBICVE',
              'SBICVS',
              'SBICWS',
              'SBIDAK',
              'SBIDBT',
              'SBIDCL',
              'SBIDEL',
              'SBIDGT',
              'SBIDIA',
              'SBIDMO',
              'SBIDMT',
              'SBIDRC',
              'SBIDRT',
              'SBIDSB',
              'SBIDTB',
              'SBIDYN',
              'SBIEES',
              'SBIEIS',
              'SBIEMM',
              'SBIEST',
              'SBIETC',
              'SBIETF',
              'SBIETM',
              'SBIEWS',
              'SBIFIJ',
              'SBIFMC',
              'SBIFMS',
              'SBIFOB',
              'SBIFRW',
              'SBIFXT',
              'SBIGAD',
              'SBIGCC',
              'SBIGKP',
              'SBIGLM',
              'SBIGLS',
              'SBIGMU',
              'SBIGOC',
              'SBIGRC',
              'SBIGUW',
              'SBIHOM',
              'SBIHRD',
              'SBIHSG',
              'SBIHUB',
              'SBIHYD',
              'SBIINB',
              'SBIINF',
              'SBIITS',
              'SBIIVM',
              'SBIJAI',
              'SBIKBN',
              'SBIKBP',
              'SBIKER',
              'SBIKOL',
              'SBIKYC',
              'SBILCM',
              'SBILCO',
              'SBILKL',
              'SBILON',
              'SBILOS',
              'SBILOT',
              'SBILTP',
              'SBILUC',
              'SBILWF',
              'SBIMAB',
              'SBIMAH',
              'SBIMAP',
              'SBIMAT',
              'SBIMBD',
              'SBIMBS',
              'SBIMET',
              'SBIMFK',
              'SBIMUM',
              'SBINPA',
              'SBINPS',
              'SBINTH',
              'SBINWC',
              'SBINWD',
              'SBINZB',
              'SBIOEM',
              'SBIONB',
              'SBIOTP',
              'SBIOTS',
              'SBIPAY',
              'SBIPBS',
              'SBIPBU',
              'SBIPEN',
              'SBIPER',
              'SBIPNJ',
              'SBIPOS',
              'SBIPPC',
              'SBIPRM',
              'SBIPSG',
              'SBIPSP',
              'SBIQCK',
              'SBIRBH',
              'SBIRBU',
              'SBIRCH',
              'SBIRDH',
              'SBIREG',
              'SBIREH',
              'SBIRMD',
              'SBIRPR',
              'SBIRTI',
              'SBIRWZ',
              'SBISAM',
              'SBISBD',
              'SBISEC',
              'SBISFG',
              'SBISMA',
              'SBISMB',
              'SBISMC',
              'SBISME',
              'SBISMP',
              'SBISNB',
              'SBISNC',
              'SBISNP',
              'SBISOC',
              'SBISOM',
              'SBISRP',
              'SBITBU',
              'SBITDS',
              'SBITFF',
              'SBITFO',
              'SBITRB',
              'SBITRI',
              'SBITRN',
              'SBITRS',
              'SBITSM',
              'SBITSS',
              'SBITST',
              'SBIUDR',
              'SBIUPI',
              'SBIVMT',
              'SBIVPN',
              'SBIWAL',
              'SBIWEB',
              'SBJSMS',
              'SBLCPC',
              'SBLLMS',
              'SBLSPC',
              'SBMCSH',
              'SBMINB',
              'SBOCAS',
              'SBPBBU',
              'SBPINB',
              'SBRACC',
              'SBRLMS',
              'SBRWDZ',
              'SBSSBI',
              'SBTINB',
              'SBWLTH',
              'SBYONO',
              'SOCINC',
              'SSCORE',
              'SSKSBH',
              'SSKSBI',
              'SSKSBM',
              'SSKSBP',
              'SSKSBT',
              'WMBSMS',
              'STELLA',
              'SUCOBK',
              'SULBNK',
              'SMUCBK',
              'SMUCBL',
              'SUNBNK',
              'SURATB',
              '120017',
              'SMFLTD',
              'SRYLTD',
              'SSBFNK',
              'SSFBNK',
              '121906',
              'SVCBNK',
              'SVCINF',
              'SVCTXN',
              'ASBALT',
              'BPMCTR',
              'BRDSEC',
              'CIRALT',
              'COVIGL',
              'DGMGZB',
              'DGMGZD',
              'DGMRBD',
              'DITATM',
              'DITHLP',
              'DMSALT',
              'EMLOTP',
              'FGMCHN',
              'FGMMUM',
              'GMCCDC',
              'GMPERS',
              'GMSMAD',
              'HOCPPC',
              'HOHRMS',
              'HOSRDD',
              'LDMFBD',
              'MBTEST',
              'NPCMPL',
              'RIMUMB',
              'ROLUDH',
              'RONELL',
              'RORURL',
              'ROTVPM',
              'ROUDPI',
              'ROVARN',
              'SBALRT',
              'STCBLR',
              'SUPRNA',
              'SWDEPT',
              'SYBGOV',
              'SYBKDC',
              'SYDBTL',
              'SYNBNK',
              'SYNBPR',
              'SYNDBK',
              'SYNDBT',
              'SYNDCT',
              'SYNDLN',
              'SYNDPG',
              'SYNEPB',
              'SYNIBD',
              'SYNINS',
              'SYNKSD',
              'SYNMOB',
              'SYNRBD',
              'SYNRUP',
              'SYNTAB',
              'SYNTST',
              'SYNVIG',
              'TDCELL',
              'THIRUV',
              '111921',
              'TMBANK',
              'TMBFST',
              'TMBOTP',
              'TMBSMS',
              'TMBUPI',
              'TCUBNK',
              'TEHBIK',
              'TGDCBT',
              'CBSTGB',
              'DCGBBK',
              'TGBATM',
              'TGBBNK',
              'TGBEBK',
              'TGBINB',
              'TGBMBS',
              'TGBTXN',
              'TGBUPI',
              'TTCOBK',
              'TGMCBK',
              'MVCBLS',
              'TBSBNK',
              '199802',
              'ADARSH',
              'ADHBNK',
              'ADBCCB',
              'AMCBNK',
              'AMCOBK',
              'AKOLAB',
              'AUCBNK',
              'ALYBNK',
              'TANCBL',
              'AZPSSB',
              'ZPSBNK',
              'ATPCCB',
              'ACCBNK',
              'APSCOB',
              'ASBANK',
              'BCRBNK',
              'BUCBBK',
              'BCUBNK',
              'BMCBBK',
              'BMCBNK',
              'BSBBMT',
              'BSBLBK',
              'TBTCOB',
              'TBNSBL',
              'BEGUBK',
              'BHABHR',
              'BMSHAB',
              'BMSNAN',
              'BCOBBK',
              'TBCBKL',
              'BUCBNK',
              'BNKBCB',
              'TBCOOP',
              'BCCBBK',
              'BHUJBK',
              'BHRDBK',
              'BSCBNK',
              'TBUCBK',
              'CNSBNK',
              'TCNSBK',
              'CHDSBK',
              'CHAMCO',
              'CNSBLH',
              'CHSBNK',
              'TCSBNK',
              'CTRCCB',
              'CPCBBK',
              'CCBJBK',
              'CCBJMU',
              'TCBMEH',
              'TCUBKK',
              'COCBNG',
              'DMCBNK',
              'DMCDHD',
              'DAHODB',
              'DUBANK',
              'DMCBKL',
              'DHARMA',
              'VSPCCB',
              'TDCCBE',
              'KKDCCB',
              'DCCBLK',
              'TECUBK',
              'CCBFAZ',
              'FZKCCB',
              'TGPCBK',
              'TGCUBK',
              '112000',
              'GUCBSI',
              'GUCBSR',
              'GUCBTR',
              '181964',
              'GUBNKO',
              'GUCBNK',
              'CITYBK',
              'GUBANK',
              'TGUCBK',
              'GNSBLT',
              'GBCBBK',
              'GBCBBN',
              'GDVBNK',
              'GSCBBK',
              'GSCBNK',
              'GTRCCB',
              'CCBGUR',
              'HMCBNK',
              'HNSBLH',
              'THNSBL',
              'HARCOB',
              '144806',
              'HASTIB',
              'HUCBNK',
              '100022',
              'HSBCBK',
              'HSBCEX',
              'HSBCIM',
              'HSBCIN',
              'HYDCCB',
              'IMCOBK',
              'IDRNSB',
              'IDRSNB',
              '122333',
              'JPCBNK',
              '133333',
              'JKBANK',
              'JKCARD',
              'TJMSBL',
              'JCBANK',
              '151899',
              'TJCCBL',
              'KDPCCB',
              'KDCBAK',
              'KTCCBL',
              'TKTCCB',
              'KNSBKL',
              '126000',
              '126001',
              '126002',
              '126003',
              'KCBANK',
              'KCMEET',
              'KCMSGS',
              'KEBANK',
              '116001',
              'NKDCCB',
              'KCCBNK',
              'KCCBPS',
              'KDCCBK',
              'TKPCBL',
              '111917',
              'KUBOTP',
              'KUBPRO',
              'KUBSMS',
              'KUBTRN',
              'KUCBOT',
              'KUCBTR',
              'KRNDBK',
              '128119',
              '150773',
              '180224',
              'KARBNK',
              'KBLBNK',
              'KRNBNK',
              'KRTBNK',
              'KTKBNK',
              'KCCDWD',
              'KCOBBK',
              '191600',
              '191607',
              'KVBANK',
              'KVBOTP',
              'KVBUPI',
              'KNSBBK',
              'TKCUBL',
              'KHEDAB',
              'KPCOBL',
              '111014',
              'KDGCCB',
              'KNSBLK',
              'TKTCBK',
              'DCCBKC',
              'KCDCCB',
              'KUCBNK',
              'TKUBNK',
              'KMBCBL',
              'CBSKUB',
              'TKUCBL',
              'KCUBNK',
              'KRICCB',
              'KNSBNK',
              'KMCBNK',
              'LVBANK',
              'LVBSMS',
              'LAXBNK',
              'LUCBNK',
              'TLUBNK',
              'LNSBNK',
              'TMUCBL',
              '119351',
              'MSCBKN',
              'MAMCOB',
              'MLBANK',
              'MCCBNK',
              'TMCCOB',
              'MAYANI',
              'MCAPEX',
              'MGSBBK',
              'TMNSBL',
              'MHSJPN',
              'MNSBKL',
              'MNSBNK',
              'MUCATM',
              'MUCBNK',
              'MUCCBS',
              'MUCINB',
              'MUCINF',
              'MUCIPO',
              'MUCMBS',
              'MUCOTP',
              'MUCUPI',
              'TMSCHT',
              'MODNAG',
              '184001',
              'MOGBNK',
              'MCBANK',
              'MCBBNK',
              'MUCOBK',
              'MPAUCB',
              '107001',
              'MCDCCB',
              'NSCBNK',
              'NSTCBL',
              'NTLBNK',
              'TNBLTD',
              'DCCBLN',
              'NUCBNK',
              'NJMSBL',
              'TNJMSB',
              'TNMCBL',
              'NDVSBK',
              'NKRDBK',
              'BETDBK',
              'TNCCBK',
              'TNCCBNK',
              '123409',
              'NCBANK',
              'NVNBNK',
              'NUCBRM',
              'NZBCCB',
              'OCUBNK',
              'PANCHB',
              'PANDBK',
              'TPMCBK',
              'PANIPT',
              'PUCBLM',
              'RAIBNK',
              'RUMBNK',
              'RCBANK',
              'RSBANK',
              'RAJNAG',
              'RNUBNK',
              'TRBANK',
              'CCBROP',
              'RPRDBK',
              'SBDCBK',
              'SKBANK',
              'SDCCBL',
              'SAMMCO',
              'SMBANK',
              'TSMCBK',
              'SUCBLS',
              'SCOPBL',
              '154987',
              'SGMCBL',
              'SPCBAK',
              'SAROBK',
              'SSBMOD',
              'CCBSAS',
              'SASCCB',
              'SEVABK',
              'SIWANB',
              'SWNCCB',
              'SDCCBS',
              'SCDCCB',
              'SIBCNP',
              'SIBPRD',
              'SIBSMS',
              'TSSKBK',
              'SCUBNK',
              'SUDBNK',
              'SUDHAB',
              'SUDICO',
              'SUTEXB',
              'SUVKAS',
              'TNSBLT',
              'TNSCBK',
              '115651',
              'TDCBNK',
              'TNYCBK',
              'DBKTNM',
              'UMUCBK',
              'UMUCBL',
              'UUCBUD',
              '180897',
              'UCTBNK',
              'UUNSBL',
              'TUCBLD',
              'URBANK',
              'UPCBNK',
              'VNSBBR',
              'VBANKL',
              'VUCBNK',
              'VCNBNK',
              'VVCCBK',
              'VARABK',
              'VNSBLK',
              'VCCBNK',
              'VASBNK',
              'VUVSBJ',
              'TVPCBK',
              'TVPCBL',
              'VCBANK',
              'VIJBNK',
              'VSVBNK',
              'WGLCCB',
              'WASHIM',
              'WUCBKL',
              'TYUBNK',
              'YUCBLY',
              'TDCBBK',
              'TJSBIB',
              'TJSBNK',
              'TJSBPM',
              'TJSBSB',
              'TJSBVV',
              'TVCBNK',
              'PSTBNK',
              'UCOBNK',
              'UPSBBK',
              'UJJIVN',
              'UJVNBP',
              'UMABNK',
              'UMACOB',
              '100026',
              'UNIONB',
              '111666',
              'AGVBNK',
              'AGVCBS',
              'BGVBNK',
              'BGVCBS',
              'MRBANK',
              'MRBCBS',
              'TGBANK',
              'TGBCBS',
              'UBIBNK',
              'UBISMS',
              'UNSBNK',
              'UCBANK',
              'UCBDHN',
              'UKGBBK',
              'UTKLGB',
              'UTKBNK',
              'UTKMIS',
              'UTKSFB',
              'UBGBNK',
              'UGBBNK',
              'UTGBBK',
              'USCBNK',
              'UTKSBK',
              'UBKGBK',
              'UBKGBM',
              'UKASHI',
              'UTKDBK',
              'VALSCB',
              'VUCBKP',
              'VVSBNK',
              'VMNBNK',
              'VSBNKL',
              'VIDYBK',
              '185241',
              'VKSBNK',
              'VIKASB',
              'VIKBNK',
              'VMCBDC',
              'WANABK',
              'WDCBNK',
              'WYDDCB',
              'YDRVBK',
              'YESBCC',
              'YESBCM',
              'YESBNK',
              'YESPAY',
              'HARDBK',
              'HARIDC',
              'BULAND',
              'DCBGZB',
              'ZSBGZB',
              'MZSBNK',
              'DCBMRT',
              'ZSBMRT',
              'GARHBK',
              'KTWBNK',
              'ZSBJBK',
              'RAMDCC',
              'ZSBRMP'
            };

            Set<String> userBankNameList = {};

            List<SmsMessage> userMessageHeader = await telephony.getInboxSms(
              columns: [SmsColumn.ADDRESS],
              filter: SmsFilter.where(SmsColumn.ADDRESS).like('%-%'),
            );

            for (SmsMessage messageHeader in userMessageHeader) {
              String? address = messageHeader.address;
              if (address != null) {
                int lastIndex = address.lastIndexOf('-') + 1;
                String substring = address.substring(lastIndex);
                if (bankNameList.contains(substring)) {
                  userBankNameList.add(substring);
                }
              }
            }

            // List<SmsMessage> messages = [];

            final String endDateString =
                (_endDate!.add(const Duration(days: 1)))
                    .millisecondsSinceEpoch
                    .toString();

            final String startDateString =
                _startDate!.millisecondsSinceEpoch.toString();

            List<SmsMessage> bankMessages = [];

            for (var bankName in userBankNameList) {
              bankName = bankName.toLowerCase();
              bankMessages += await telephony.getInboxSms(
                columns: [SmsColumn.ADDRESS, SmsColumn.BODY, SmsColumn.DATE],
                filter: SmsFilter.where(SmsColumn.ADDRESS)
                    .like('%$bankName')
                    .and(SmsColumn.DATE)
                    .greaterThanOrEqualTo(startDateString)
                    .and(SmsColumn.DATE)
                    .lessThanOrEqualTo(
                        endDateString), // Use the precalculated end date
                // sortOrder: [OrderBy(SmsColumn.DATE, sort: Sort.DESC)],
              );
              // messages.addAll(bankMessages);
            }

            Map<String, dynamic> bankTemplates = {};
            Map<String, dynamic> transactionInfo = {};
            // Future<bool> updateTemplate(String bankName, String message) async {
            //   try {
            //     // if(message==null) return false;
            //     print(bankName);
            //     print(message);
            //     var response = await Dio().put(
            //       'http://192.168.85.139:8000/bank/update',
            //       data: {
            //         'bankName': bankName,
            //         'message': message,
            //       },
            //     );
            //     if (response.statusCode == 200 &&
            //         response.data['success'] == true) {
            //       // Template added successfully, update bankTemplates
            //       var newTemplate = response.data['data']['template'];
            //       bankTemplates[bankName] = newTemplate;
            //       print(
            //           'Unmatched Template removed successfully for bank $bankName');
            //       return true;
            //     } else {
            //       print(
            //           'Failed to remove unmatched template for bank $bankName');
            //       return false;
            //     }
            //   } catch (e) {
            //     print('Error adding template for bank $bankName: $e');
            //   }
            //   return false;
            // }

            Future<bool> checkRegexMatch(
                List<dynamic> bankObjList, String body, String bankName) async {
              try {
                for (var bankObj in bankObjList) {
                  var regex = RegExp(bankObj['regexPattern']);
                  var match = regex.firstMatch(body);
                  var propertyMapString = bankObj['propertyMap'];
                  var propertyMap = json.decode(propertyMapString);
                  if (match != null) {
                    print('Regex pattern matched after adding new template');
                    transactionInfo = {
                      'accountNumber':
                          int.parse(propertyMap['accountNumber'].toString()) ==
                                  -1
                              ? ""
                              : match.group(int.parse(
                                  propertyMap['accountNumber'].toString())),
                      'date': int.parse(propertyMap['date'].toString()) == -1
                          ? ""
                          : match
                              .group(int.parse(propertyMap['date'].toString())),
                      'time': int.parse(propertyMap['time'].toString()) == -1
                          ? ""
                          : match
                              .group(int.parse(propertyMap['time'].toString())),
                      'transactionId':
                          int.parse(propertyMap['transactionId'].toString()) ==
                                  -1
                              ? ""
                              : match.group(int.parse(
                                  propertyMap['transactionId'].toString())),
                      'transactionType': bankObj['transactionType'],
                    };

                    // Extract amount if it exists in propertyMap
                    if (propertyMap.containsKey('amount')) {
                      var amountIndex = propertyMap['amount'];
                      var amountString = match.group(amountIndex);
                      if (amountString != null) {
                        // Remove commas from the amount string
                        var cleanedAmountString =
                            amountString.replaceAll(",", "");
                        // Convert the cleaned amount string to a double
                        transactionInfo['amount'] =
                            double.parse(cleanedAmountString);
                      } else {
                        // Handle the case when amount is not captured
                        transactionInfo['amount'] =
                            null; // Or any other default value
                      }
                    } else {
                      transactionInfo['amount'] = 0;
                    }

                    // Check if body contains 'credit' or 'debit' and set type accordingly
                    if (transactionInfo['transactionType'] == 'credited') {
                      print("credited");
                      transactionInfo['type'] = 'credited';
                      creditedMessages.add(body);
                      creditedAmount += transactionInfo['amount'];
                    } else if (transactionInfo['transactionType'] ==
                        'debited') {
                      transactionInfo['type'] = 'debited';
                      debitedMessages.add(body);
                      debitedAmount += transactionInfo['amount'];
                    } else {
                      transactionInfo['transactionType'] =
                          null; // Neither credit nor debit
                    }

                    // Print transaction info
                    print('Transaction Info: $transactionInfo');
                    return true;
                  }
                }
                return false; // Return false if no template matches
              } catch (e) {
                print('Error while checking regex match: $e');
                // User can report and the existing template
                // if(await updateTemplate(bankName, body)) {
                //   print("Template removed successfully");
                // };
                // await addNewTemplate(bankName, body);
                // we will get a report add messaages to probablySpamList
                return false;
              }
            }

            Future<void> addNewTemplate(String bankName, String message) async {
              try {
                print(bankName);
                print(message);
                var response = await Dio().post(
                  'http://192.168.85.139:8000/bank/add',
                  data: {
                    'bankName': bankName,
                    'message': message,
                  },
                );
                if (response.statusCode == 200 &&
                    response.data['success'] == true) {
                  // Template added successfully, update bankTemplates
                  var newTemplate = response.data['data']['template'];
                  bankTemplates[bankName] = newTemplate;
                  var updatedBankObj = bankTemplates[bankName];
                  if (await checkRegexMatch(
                      updatedBankObj, message, bankName)) {
                    print(
                        'Regex pattern matched for bank $bankName after adding new template');
                    // Handle the matched pattern accordingly
                  } else {
                    print(
                        'Regex pattern still did not match for bank $bankName after adding new template');
                    // Handle the case where the regex pattern still doesn't match after adding new template
                  }
                  print('Template added successfully for bank $bankName');
                } else if (response.statusCode == 201 &&
                    response.data['success'] == true) {
                  print("Map returned from backend");
                  // let result = { bankName: bankName, features: features };
                  print("Null eror start");
                  print(response.data);
                  var tempMap = json.decode(response.data['data']['features']);
                  print(tempMap);
                  print("Null eror end");

                  transactionInfo = {
                    'accountNumber': tempMap['accountNumber'],
                    'date': tempMap['date'],
                    'time': tempMap['time'],
                    'amount': tempMap['amount'],
                    'transactionId': tempMap['transactionId'],
                    'transactionType': tempMap['isCreditOrDebit'],
                  };

                  var cleanedAmountString =
                      transactionInfo['amount'].replaceAll(",", "");
                  transactionInfo['amount'] =
                      double.parse(cleanedAmountString) == -1
                          ? 0
                          : double.parse(cleanedAmountString);

                  // Check if body contains 'credit' or 'debit' and set type accordingly
                  if (transactionInfo['transactionType'] == 'credited') {
                    print("credited");
                    // transactionInfo['type'] = 'credited';
                    creditedMessages.add(message);
                    creditedAmount += transactionInfo['amount'];
                  } else if (transactionInfo['transactionType'] == 'debited') {
                    // transactionInfo['type'] = 'debited';
                    debitedMessages.add(message);
                    debitedAmount += transactionInfo['amount'];
                  } else {
                    transactionInfo['transactionType'] =
                        null; // Neither credit nor debit
                  }

                  print(transactionInfo);
                } else {
                  print('Failed to add template for bank $bankName');
                }
              } catch (e) {
                print('Error adding template for bank $bankName: $e');
              }
            }

            Future<void> getData(String bankName, String body) async {
              try {
                if (bankTemplates.containsKey(bankName)) {
                  var bankObj = bankTemplates[bankName];

                  // Check if the regex pattern matches the body
                  if (await checkRegexMatch(bankObj, body, bankName)) {
                    print('Regex pattern matched for bank $bankName');
                    // Handle the matched pattern accordingly
                    return;
                  } else {
                    print(
                        'Regex pattern did not match for bank $bankName. Wait while creating new template.');
                    await addNewTemplate(bankName, body);
                    // Check again if regex pattern matches after adding new template
                  }
                } else {
                  await addNewTemplate(bankName, body);
                  // Check again if regex pattern matches after adding new template
                }
              } catch (e) {
                print(e);
              }
            }

            for (var messageObj in bankMessages) {
              String header = messageObj.address ?? '';
              if (header.length > 6)
                header = header.substring(header.length - 6).toLowerCase();
              String body = (messageObj.body ?? '').replaceAll('\n', ' ');
              if (body.toLowerCase().contains('credit') ||
                  body.toLowerCase().contains('debit') ||
                  body.toLowerCase().contains('credited') ||
                  body.toLowerCase().contains('sent') ||
                  body.toLowerCase().contains('inr') ||
                  body.toLowerCase().contains('rs') ||
                  body.toLowerCase().contains('received')) {
                await getData(header, body);
              }
            }

            // for (var message in bankMessages) {
            //   // if message.body is null, it will assign an empty string ('') to body
            //   String body = (message.body ?? '').replaceAll('\n', ' ');
            //   String lowercaseBody = body.toLowerCase();
            //   double amount = _extractAmount(body);

            //   //if (body.contains('UPI') || body.contains('IMPS') || body.contains('NEFT') || body.contains('UPI LITE') || body.contains('NPCI') || body.contains('POS') || body.contains('AePS') || body.contains('MPOS') || body.contains('BBPS') || body.contains('NETS') || body.contains('RFID') || body.contains('e-RUPI') || body.contains('UPI 123PAY') || body.contains('SELF'))

            //   // print('Message: ${message.body}');
            //   print('Date: ${message.date}');
            //   print('Date: ${message.address}');
            //   if (lowercaseBody.contains('credit') ||
            //       lowercaseBody.contains('credited')) {
            //     creditedMessages.add(body);
            //     creditedAmount += amount;
            //   } else if ((lowercaseBody.contains('debit') ||
            //       lowercaseBody.contains('debited'))) {
            //     debitedMessages.add(body);
            //     debitedAmount += amount;
            //     // print(amount);
            //   }
            // }

            setState(() {
              _creditedMessages = creditedMessages;
              _debitedMessages = debitedMessages;
              totalCreditedAmount = creditedAmount;
              totalDebitedAmount = debitedAmount;
            });
          }
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }

  // double _extractAmount(String body) {
  //   RegExp regExp = RegExp(r'\b(?:0|[1-9]\d*)\.\d+\b');
  //   Match? match = regExp.firstMatch(body);
  //   return match != null ? double.parse(match.group(0)!) : 0.0;
  // }
}

class _DateFilter extends StatelessWidget {
  final Function(DateTime)? onStartDateSelected;
  final Function(DateTime)? onEndDateSelected;

  const _DateFilter({
    Key? key,
    this.onStartDateSelected,
    this.onEndDateSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () async {
            DateTime? selectedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime.now(),
            );
            if (selectedDate != null && onStartDateSelected != null) {
              onStartDateSelected!(selectedDate);
            }
          },
          child: const Text('Start Date'),
        ),
        ElevatedButton(
          onPressed: () async {
            DateTime? selectedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime.now(),
            );
            if (selectedDate != null && onEndDateSelected != null) {
              onEndDateSelected!(selectedDate);
            }
          },
          child: const Text('End Date'),
        ),
      ],
    );
  }
}

class _MessageSection extends StatelessWidget {
  const _MessageSection({
    Key? key,
    required this.title,
    required this.messages,
  }) : super(key: key);

  final String title;
  final List<String?> messages;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        if (messages.isNotEmpty)
          SizedBox(
            height: 200, // Set a fixed height or use Expanded
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(messages[index]!),
                );
              },
            ),
          )
        else
          Text('No $title messages to show.'),
      ],
    );
  }
}

class _TotalAmountSection extends StatelessWidget {
  final double totalCreditedAmount;
  final double totalDebitedAmount;

  const _TotalAmountSection({
    Key? key,
    required this.totalCreditedAmount,
    required this.totalDebitedAmount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Round credited and debited amounts to two decimal places
    String creditedAmountString = totalCreditedAmount.toStringAsFixed(2);
    String debitedAmountString = totalDebitedAmount.toStringAsFixed(2);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Total Credited Amount: $creditedAmountString',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        Text('Total Debited Amount: $debitedAmountString',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
