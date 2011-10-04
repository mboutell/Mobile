package edu.rosehulman.android.directory.service;

import java.util.HashMap;
import java.util.Map;

import org.apache.http.NameValuePair;
import org.json.JSONException;
import org.json.JSONObject;

/**
 * Like the real JsonClient, except that it doesn't actually
 * talk to a web server.  It simply serves static data and will
 * be useful for unit testing in a controlled environment.
 */
public class MockJsonClient extends JsonClient {
	
	private static final String MAP_AREAS_RESPONSE = "{'Areas':[{'Center':{'Lat':39.4821800526708,'Long':-87.3222422754326},'Corners':[{'Lat':39.4822230890006,'Long':-87.3227218614464},{'Lat':39.4822582821818,'Long':-87.3225743399506},{'Lat':39.4824735812559,'Long':-87.3222792969589},{'Lat':39.4824611601736,'Long':-87.3222605214958},{'Lat':39.4825253357417,'Long':-87.3221827374344},{'Lat':39.4823721423521,'Long':-87.3219064699059},{'Lat':39.4823307386754,'Long':-87.3219627962952},{'Lat':39.4822458610611,'Long':-87.3218233214264},{'Lat':39.4820533334056,'Long':-87.3220110760574},{'Lat':39.482030561282,'Long':-87.3219896183853},{'Lat':39.4819063495679,'Long':-87.3221720085983},{'Lat':39.4818483840254,'Long':-87.3221827374344},{'Lat':39.481989157402,'Long':-87.3226199375038}],'Description':'Hatfield Hall is a building.  It is cool.  Plays and stuff.','Id':0,'LabelOnHybrid':false,'MinZoomLevel':14,'Name':'Hatfield Hall'},{'Center':{'Lat':39.4828921940196,'Long':-87.3240715419807},'Corners':[{'Lat':39.4829455807401,'Long':-87.324269496048},{'Lat':39.4830159663536,'Long':-87.3239503131752},{'Lat':39.4828462126939,'Long':-87.3238859401588},{'Lat':39.482771686566,'Long':-87.3241997586136}],'Description':'','Id':1,'LabelOnHybrid':true,'MinZoomLevel':16,'Name':'Hadley Hall'},{'Center':{'Lat':39.4827969662383,'Long':-87.3246991788902},'Corners':[{'Lat':39.4828896862316,'Long':-87.3253665195351},{'Lat':39.4829787033906,'Long':-87.324985645855},{'Lat':39.4829352299086,'Long':-87.3249641881828},{'Lat':39.4830718607607,'Long':-87.3243526445274},{'Lat':39.4826350551242,'Long':-87.3241890297775},{'Lat':39.4825149848477,'Long':-87.3247362004166},{'Lat':39.4828400021863,'Long':-87.3248488531952},{'Lat':39.4827841075929,'Long':-87.3251465783958},{'Lat':39.4826267744222,'Long':-87.3250848875885},{'Lat':39.4825688094801,'Long':-87.3252672778015}],'Description':'','Id':2,'LabelOnHybrid':true,'MinZoomLevel':15,'Name':'Olin Hall'},{'Center':{'Lat':39.4834262952456,'Long':-87.323765770153},'Corners':[{'Lat':39.4838688687147,'Long':-87.3242185340767},{'Lat':39.4839827262482,'Long':-87.3237035499458},{'Lat':39.4829931945453,'Long':-87.3233253584747},{'Lat':39.4828731248871,'Long':-87.3238618002777}],'Description':'','Id':3,'LabelOnHybrid':true,'MinZoomLevel':16,'Name':'Moench Hall'},{'Center':{'Lat':39.4837285367578,'Long':-87.3244470512428},'Corners':[{'Lat':39.4837632915625,'Long':-87.3247013316994},{'Lat':39.4838605881595,'Long':-87.3242909537201},{'Lat':39.4836991171368,'Long':-87.3242238984947},{'Lat':39.4836038904604,'Long':-87.3246450053101}],'Description':'','Id':4,'LabelOnHybrid':true,'MinZoomLevel':15,'Name':'Crapo Hall'},{'Center':{'Lat':39.4833683309699,'Long':-87.324838653759},'Corners':[{'Lat':39.4834527695977,'Long':-87.3250848875885},{'Lat':39.4835376457391,'Long':-87.3246745096092},{'Lat':39.4833927351912,'Long':-87.3246101365929},{'Lat':39.4833016484066,'Long':-87.3250231967812}],'Description':'','Id':5,'LabelOnHybrid':true,'MinZoomLevel':14,'Name':'Logan Library'},{'Center':{'Lat':39.4836664324447,'Long':-87.3232507860222},'Corners':[{'Lat':39.4837355634516,'Long':-87.3234127949677},{'Lat':39.4837987027733,'Long':-87.3231553029023},{'Lat':39.4836051443432,'Long':-87.3230761777363},{'Lat':39.48354303992,'Long':-87.3233363520108}],'Description':'','Id':6,'LabelOnHybrid':true,'MinZoomLevel':16,'Name':'Rotz Mechanical Engineering Lab'},{'Center':{'Lat':39.483927270187,'Long':-87.3230737602272},'Corners':[{'Lat':39.4840026113389,'Long':-87.3235281299553},{'Lat':39.484074030948896,'Long':-87.3231928538285},{'Lat':39.4841713271112,'Long':-87.3232277225457},{'Lat':39.4842272205897,'Long':-87.3229755948983},{'Lat':39.4836258458053,'Long':-87.3227113973103},{'Lat':39.4836020391234,'Long':-87.3228066157303},{'Lat':39.4836237756594,'Long':-87.3228200267754},{'Lat':39.4835958286833,'Long':-87.3229340206585},{'Lat':39.4839156656277,'Long':-87.3230627666912},{'Lat':39.4838276847379,'Long':-87.323469121357}],'Description':'','Id':7,'LabelOnHybrid':true,'MinZoomLevel':16,'Name':'Myers Hall'},{'Center':{'Lat':39.4849499103115,'Long':-87.3218614017525},'Corners':[{'Lat':39.485063328468,'Long':-87.3222216294651},{'Lat':39.4850571181583,'Long':-87.3215135262852},{'Lat':39.4848459673015,'Long':-87.3215215729122},{'Lat':39.4848542477393,'Long':-87.3222323583012}],'Description':'','Id':8,'LabelOnHybrid':true,'MinZoomLevel':15,'Name':'Facilities Operations'},{'Center':{'Lat':39.4846228327172,'Long':-87.3200750505486},'Corners':[{'Lat':39.4846754018593,'Long':-87.3203416656456},{'Lat':39.4846836823175,'Long':-87.3198293637238},{'Lat':39.4845656856958,'Long':-87.3198293637238},{'Lat':39.4845625805188,'Long':-87.3203403245411}],'Description':'','Id':9,'LabelOnHybrid':true,'MinZoomLevel':16,'Name':'Recycling Center'},{'Center':{'Lat':39.4840721796215,'Long':-87.3211345231094},'Corners':[{'Lat':39.4843211925432,'Long':-87.3214451299553},{'Lat':39.4843915767645,'Long':-87.3213512526398},{'Lat':39.4842073355638,'Long':-87.3211044894104},{'Lat':39.4842052654352,'Long':-87.3209891544228},{'Lat':39.4841224602397,'Long':-87.3209864722137},{'Lat':39.4841245303708,'Long':-87.3210562096481},{'Lat':39.4839444287356,'Long':-87.3210535274391},{'Lat':39.4839444287356,'Long':-87.3212251888161},{'Lat':39.4841473018087,'Long':-87.321217142189}],'Description':'','Id':10,'LabelOnHybrid':true,'MinZoomLevel':16,'Name':'Alpha Tau Omega'},{'Center':{'Lat':39.4836167489548,'Long':-87.3211318409004},'Corners':[{'Lat':39.4837663967757,'Long':-87.3213592992668},{'Lat':39.4837684669174,'Long':-87.3209194169884},{'Lat':39.4836380478707,'Long':-87.3209194169884},{'Lat':39.4836380478707,'Long':-87.321037434185},{'Lat':39.4833958404209,'Long':-87.321040116394},{'Lat':39.4833958404209,'Long':-87.32121445998},{'Lat':39.4836380478707,'Long':-87.321217142189},{'Lat':39.4836380478707,'Long':-87.3213512526398}],'Description':'','Id':11,'LabelOnHybrid':true,'MinZoomLevel':16,'Name':'Triangle'},{'Center':{'Lat':39.4830391757744,'Long':-87.3210030948677},'Corners':[{'Lat':39.4832053861073,'Long':-87.3211608157997},{'Lat':39.4832053861073,'Long':-87.3208684550171},{'Lat':39.4829300544928,'Long':-87.3208657728081},{'Lat':39.4829321246594,'Long':-87.321211777771},{'Lat':39.4830356329099,'Long':-87.321217142189},{'Lat':39.4830377030734,'Long':-87.3211634980087}],'Description':'','Id':12,'LabelOnHybrid':true,'MinZoomLevel':16,'Name':'Lambda Chi Alpha Theta Kappa'},{'Center':{'Lat':39.4823870712574,'Long':-87.3207348739662},'Corners':[{'Lat':39.4826091779276,'Long':-87.3207960353737},{'Lat':39.4826071077514,'Long':-87.32066997155},{'Lat':39.482164088628,'Long':-87.320678018177},{'Lat':39.4821620184386,'Long':-87.3207987175827}],'Description':'','Id':13,'LabelOnHybrid':true,'MinZoomLevel':16,'Name':'Skinner Hall'},{'Center':{'Lat':39.4819813142498,'Long':-87.3209467684784},'Corners':[{'Lat':39.4819984732778,'Long':-87.3210723029022},{'Lat':39.4820419473454,'Long':-87.3208657728081},{'Lat':39.4819322270273,'Long':-87.3208228574638},{'Lat':39.481882542298,'Long':-87.321029387558}],'Description':'','Id':14,'LabelOnHybrid':true,'MinZoomLevel':16,'Name':'Circle K'},{'Center':{'Lat':39.4819295593592,'Long':-87.3204076444664},'Corners':[{'Lat':39.4819425780081,'Long':-87.3205331788902},{'Lat':39.4819964030835,'Long':-87.3203239665871},{'Lat':39.481913595258,'Long':-87.3202864156609},{'Lat':39.4818597701186,'Long':-87.320495627964}],'Description':'','Id':15,'LabelOnHybrid':true,'MinZoomLevel':16,'Name':'Public Safety'},{'Center':{'Lat':39.4824458607434,'Long':-87.3257211005249},'Corners':[{'Lat':39.4827913531918,'Long':-87.3256535158997},{'Lat':39.4827603006238,'Long':-87.3255515919571},{'Lat':39.4826029673992,'Long':-87.3256213293915},{'Lat':39.4825926165167,'Long':-87.3255784140472},{'Lat':39.4821723693856,'Long':-87.3257903085594},{'Lat':39.4822096327806,'Long':-87.3260075674896},{'Lat':39.4823276333998,'Long':-87.3259458766823},{'Lat':39.482304861366,'Long':-87.3258761392479}],'Description':'','Id':16,'LabelOnHybrid':true,'MinZoomLevel':15,'Name':'BSB Hall'},{'Center':{'Lat':39.4834333300823,'Long':-87.3257801091232},'Corners':[{'Lat':39.4835904345075,'Long':-87.3259887920265},{'Lat':39.4833813493506,'Long':-87.3255220876579},{'Lat':39.4832778416146,'Long':-87.3255971895103},{'Lat':39.4834910673826,'Long':-87.3260531650429}],'Description':'','Id':17,'LabelOnHybrid':true,'MinZoomLevel':16,'Name':'Deming Hall'},{'Center':{'Lat':39.4835906614289,'Long':-87.326818124012},'Corners':[{'Lat':39.4838636933688,'Long':-87.3272842989807},{'Lat':39.483884394754,'Long':-87.3268846498375},{'Lat':39.4837394849286,'Long':-87.3268873320465},{'Lat':39.4837519057826,'Long':-87.3263455258255},{'Lat':39.4833730687374,'Long':-87.3263455258255},{'Lat':39.4833585776619,'Long':-87.3266700731163},{'Lat':39.4834869270827,'Long':-87.3266727553253},{'Lat':39.4834827867825,'Long':-87.3268685565834},{'Lat':39.4833254551923,'Long':-87.3268685565834},{'Lat':39.4833213148825,'Long':-87.3272950278168}],'Description':'','Id':18,'LabelOnHybrid':true,'MinZoomLevel':16,'Name':'Hulman Memorial Union'},{'Center':{'Lat':39.4821291223258,'Long':-87.3267376577415},'Corners':[{'Lat':39.4821042719261,'Long':-87.3270565759144},{'Lat':39.4822026059383,'Long':-87.3266542445622},{'Lat':39.4822450447848,'Long':-87.3266703378163},{'Lat':39.4822678168381,'Long':-87.3265858482323},{'Lat':39.4822202025363,'Long':-87.3265630494557},{'Lat':39.4822357289426,'Long':-87.3264933120213},{'Lat':39.4821394651675,'Long':-87.3264571021996},{'Lat':39.4820763243394,'Long':-87.3267011832199},{'Lat':39.482055622416,'Long':-87.3266904543839},{'Lat':39.4820359555832,'Long':-87.3267628740273},{'Lat':39.4820628680899,'Long':-87.3267762850724},{'Lat':39.4820038675807,'Long':-87.3270203660927}],'Description':'','Id':19,'LabelOnHybrid':true,'MinZoomLevel':16,'Name':'Speed Hall'},{'Center':{'Lat':39.4821374030872,'Long':-87.3283094322243},'Corners':[{'Lat':39.4822077814088,'Long':-87.3283561061821},{'Lat':39.4822543606258,'Long':-87.3278934251271},{'Lat':39.4822264130993,'Long':-87.3278894018135},{'Lat':39.482231588568,'Long':-87.3278223465882},{'Lat':39.4821291142161,'Long':-87.3278089355431},{'Lat':39.4821229036444,'Long':-87.327888060709},{'Lat':39.4821032368306,'Long':-87.3278853785},{'Lat':39.4820204291324,'Long':-87.328786600729},{'Lat':39.4821560266868,'Long':-87.3287933062516},{'Lat':39.482191219902,'Long':-87.3283534239731}],'Description':'','Id':20,'LabelOnHybrid':true,'MinZoomLevel':15,'Name':'Percopo Hall'},{'Center':{'Lat':39.4835409778845,'Long':-87.3277622615852},'Corners':[{'Lat':39.4836299861007,'Long':-87.3278545330963},{'Lat':39.4836486174102,'Long':-87.3277619968853},{'Lat':39.4836227405901,'Long':-87.3277552913628},{'Lat':39.4836351614649,'Long':-87.327705670496},{'Lat':39.4834912861952,'Long':-87.3276520263157},{'Lat':39.4834767951444,'Long':-87.3276936005554},{'Lat':39.4834581637888,'Long':-87.3276855539284},{'Lat':39.4834343570495,'Long':-87.3277727257214},{'Lat':39.4834591988643,'Long':-87.327787477871},{'Lat':39.4834488481092,'Long':-87.3278303932152},{'Lat':39.483595828687,'Long':-87.327890742918},{'Lat':39.4836092846398,'Long':-87.3278505097828}],'Description':'','Id':21,'LabelOnHybrid':true,'MinZoomLevel':16,'Name':'Mees Hall'},{'Center':{'Lat':39.4836403449381,'Long':-87.3281216775932},'Corners':[{'Lat':39.4837283179557,'Long':-87.3282045613728},{'Lat':39.48374798431,'Long':-87.3281080018483},{'Lat':39.4837272828842,'Long':-87.3281012963257},{'Lat':39.4837365985266,'Long':-87.3280556987725},{'Lat':39.4835844428787,'Long':-87.3279966901741},{'Lat':39.4835699518472,'Long':-87.3280556987725},{'Lat':39.4835564958867,'Long':-87.3280489932499},{'Lat':39.4835316541067,'Long':-87.3281334828339},{'Lat':39.4835492503685,'Long':-87.328146893879},{'Lat':39.4835368294783,'Long':-87.3281884681187},{'Lat':39.4836941605902,'Long':-87.3282461356125},{'Lat':39.4837086515958,'Long':-87.3281965147457}],'Description':'','Id':22,'LabelOnHybrid':true,'MinZoomLevel':16,'Name':'Scharpenberg Hall'},{'Center':{'Lat':39.4833877867321,'Long':-87.3283469831505},'Corners':[{'Lat':39.4834726548436,'Long':-87.3284392546616},{'Lat':39.4834985317195,'Long':-87.328340012928},{'Lat':39.4834778302195,'Long':-87.3283306251965},{'Lat':39.4834850757452,'Long':-87.3282877098522},{'Lat':39.4833360247789,'Long':-87.3282179724179},{'Lat':39.4833194635407,'Long':-87.3282823454342},{'Lat':39.4832977269095,'Long':-87.3282716165982},{'Lat':39.4832739201153,'Long':-87.3283614706002},{'Lat':39.4832966918317,'Long':-87.3283748816452},{'Lat':39.4832832358183,'Long':-87.3284151147805},{'Lat':39.4834384973526,'Long':-87.3284768055878},{'Lat':39.4834509182603,'Long':-87.32842986693}],'Description':'','Id':23,'LabelOnHybrid':true,'MinZoomLevel':16,'Name':'Blumberg Hall'},{'Center':{'Lat':39.4836196434803,'Long':-87.3292642986336},'Corners':[{'Lat':39.4837842117906,'Long':-87.3294289897881},{'Lat':39.483820439252,'Long':-87.3292506228886},{'Lat':39.4837666155883,'Long':-87.32923318853},{'Lat':39.4837987027774,'Long':-87.3290816437207},{'Lat':39.4838349302312,'Long':-87.3290950547657},{'Lat':39.483929230929,'Long':-87.3286365293741},{'Lat':39.4837180766476,'Long':-87.3285694741488},{'Lat':39.4836275078255,'Long':-87.3289952748299},{'Lat':39.4836611476875,'Long':-87.3290046625614},{'Lat':39.4836445865267,'Long':-87.3290864699364},{'Lat':39.4837066908593,'Long':-87.3291052453995},{'Lat':39.4836865069573,'Long':-87.3292064987898},{'Lat':39.4834587907339,'Long':-87.3291307263851},{'Lat':39.483425668312,'Long':-87.3292956822395},{'Lat':39.4834650011862,'Long':-87.3293084227324},{'Lat':39.483425668312,'Long':-87.3294988595724},{'Lat':39.483389440645,'Long':-87.3294854485274},{'Lat':39.4833019766284,'Long':-87.3299186252833},{'Lat':39.4835064041877,'Long':-87.3299843394041},{'Lat':39.4836016309975,'Long':-87.3295229994536},{'Lat':39.4835679911068,'Long':-87.3295116000652},{'Lat':39.4835845522858,'Long':-87.3294284515858},{'Lat':39.4835338336626,'Long':-87.3294123583317},{'Lat':39.4835472896275,'Long':-87.3293533497334}],'Description':'','Id':24,'LabelOnHybrid':false,'MinZoomLevel':15,'Name':'Apartments'},{'Center':{'Lat':39.4850314687824,'Long':-87.3274403965034},'Corners':[{'Lat':39.4851021428863,'Long':-87.3283357249146},{'Lat':39.4854768303311,'Long':-87.3268202768211},{'Lat':39.4845701246484,'Long':-87.3264125810509},{'Lat':39.4844748991647,'Long':-87.3267505393868},{'Lat':39.484452127834,'Long':-87.3272011505013},{'Lat':39.4845163015649,'Long':-87.3272306548004},{'Lat':39.4845804752366,'Long':-87.3277349100952},{'Lat':39.4844956003679,'Long':-87.3281104193573}],'Description':'','Id':25,'LabelOnHybrid':true,'MinZoomLevel':14,'Name':'SRC'},{'Center':{'Lat':39.4825017556092,'Long':-87.3293823158302},'Corners':[{'Lat':39.4825499885642,'Long':-87.3296054773808},{'Lat':39.482580523682,'Long':-87.3294874601841},{'Lat':39.4825624096307,'Long':-87.3294794135571},{'Lat':39.4826183044022,'Long':-87.3292567902088},{'Lat':39.4824506199528,'Long':-87.3291870527744},{'Lat':39.4824004180483,'Long':-87.329418393302},{'Lat':39.4824299181409,'Long':-87.3294425331831},{'Lat':39.4824045584129,'Long':-87.3295390927076}],'Description':'','Id':26,'LabelOnHybrid':true,'MinZoomLevel':14,'Name':'White Chapel'}],'Version':0.1}";

	public MockJsonClient(String host, int port, String path) {
		super(host, port, path);
	}
	
	private JSONObject makeResponse(String response) throws JSONException {
		return new JSONObject(response.replace("'", "\""));
	}
	
	private JSONObject getResponse() {
		Map<String, String> params = new HashMap<String, String>();
		for (NameValuePair pair : queryParams) {
			params.put(pair.getName(), pair.getValue());
		}
		
		try {
			if ("mapareas".equals(path)) {
				if (params.containsKey("version") &&
						"0.1".equals(params.get("version"))) {
					//data up to date
					return null;
				}
				
				return makeResponse(MAP_AREAS_RESPONSE);
			} else {
				throw new RuntimeException("Invalid request: " + path);
			}
		} catch (JSONException ex) {
			//we messed up
			throw new RuntimeException("Failed to parse JSON string", ex);
		}		
	}
	
	@Override
	public JSONObject execute() {
		JSONObject response = getResponse();
		
		try {
			//simulate some network latency
			Thread.sleep(2000);
		} catch (InterruptedException e) {
			//nom
		}
		
		return response;
	}

}
