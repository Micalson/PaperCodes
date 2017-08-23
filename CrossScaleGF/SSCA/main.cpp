///////////////////////////////////////////////////////
// File: main.cpp
// Desc: Scale Space Cost Aggregation
// Usage: [CC_METHOD] [CA_METHOD] [USE_MED] [lImg] [rImg] [lDis] [maxDis] [disSc]
// Author: Zhang Kang
// Date: 2013/09/06
///////////////////////////////////////////////////////
#include "CommFunc.h"
#include "SSCA.h"
#include "CC/GrdCC.h"
#include "CAFilter/GuidedFilter.h"
#include "GetMehod.h"


//#define USE_MEDIAN_FILTER

#ifdef USE_MEDIAN_FILTER
#include"CAST/Toolkit.h"
#endif

#ifdef COMPUTE_RIGHT
int main( int argc, char** argv )
{
	printf( "Scale Space Cost Aggregation\n" );
	if( argc != 11 ) {
		printf( "Usage: [CC_METHOD] [CA_METHOD] [PP_METHOD] [C_ALPHA] [lImg] [rImg] [lDis] [rDis] [maxDis] [disSc]\n" );
		printf( "\nPress any key to continue...\n" );
		getchar();
		return -1;
	}
	string ccName = argv[ 1 ];
	string caName = argv[ 2 ];
	string ppName = argv[ 3 ];
	double costAlpha = atof( argv[ 4 ] );
	string lFn = argv[ 5 ];
	string rFn = argv[ 6 ];
	string lDisFn = argv[ 7 ];
	string rDisFn = argv[ 8 ];
	int maxDis = atoi( argv[ 9 ] );
	int disSc  = atoi( argv[ 10 ] );
	//
	// Load left right image
	//
	printf( "\n--------------------------------------------------------\n" );
	printf( "Load Image: (%s) (%s)\n", argv[ 5 ], argv[ 6 ] );
	printf( "--------------------------------------------------------\n" );
	Mat lImg = imread( lFn, CV_LOAD_IMAGE_COLOR );
	Mat rImg = imread( rFn, CV_LOAD_IMAGE_COLOR );
	if( !lImg.data || !rImg.data ) {
		printf( "Error: can not open image\n" );
		printf( "\nPress any key to continue...\n" );
		getchar();
		return -1;
	}
	// set image format
	cvtColor( lImg, lImg, CV_BGR2RGB );
	cvtColor( rImg, rImg, CV_BGR2RGB );
	lImg.convertTo( lImg, CV_64F, 1 / 255.0f );
	rImg.convertTo( rImg, CV_64F,  1 / 255.0f );

	// time
	double duration;
	duration = static_cast<double>(getTickCount());

	//
	// Stereo Match at each pyramid
	//
	int PY_LVL = 5;
	// build pyramid and cost volume
	Mat lP = lImg.clone();
	Mat rP = rImg.clone();
	SSCA** smPyr = new SSCA*[ PY_LVL ];
	CCMethod* ccMtd = getCCType( ccName );
	CAMethod* caMtd = getCAType( caName );
	PPMethod* ppMtd = getPPType( ppName );
	for( int p = 0; p < PY_LVL; p ++ ) {
		if( maxDis < 5 ) {
			PY_LVL = p;
			break;
		}
		printf( "\n\tPyramid: %d:", p );
		smPyr[ p ] = new SSCA( lP, rP, maxDis, disSc );


		smPyr[ p ]->CostCompute( ccMtd );

		smPyr[ p ]->CostAggre( caMtd  );
		// pyramid downsample
		maxDis = maxDis / 2 + 1;
		disSc  *= 2;
		pyrDown( lP, lP );
		pyrDown( rP, rP );
	}
	printf( "\n--------------------------------------------------------\n" );
	printf( "\n Cost Aggregation in Scale Space\n" );
	printf( "\n--------------------------------------------------------\n" );
	// new method
	SolveAll( smPyr, PY_LVL, costAlpha );

	// old method
	//for( int p = PY_LVL - 2 ; p >= 0; p -- ) {
	//	smPyr[ p ]->AddPyrCostVol( smPyr[ p + 1 ], costAlpha );
	//}

	//
	// Match + Postprocess
	//
	smPyr[ 0 ]->Match();
	smPyr[ 0 ]->PostProcess( ppMtd );
	Mat lDis = smPyr[ 0 ]->getLDis();
	Mat rDis = smPyr[ 0 ]->getRDis();
#ifdef _DEBUG
	for( int s = 0; s < PY_LVL; s ++ ) {
		smPyr[ s ]->Match();
		Mat sDis = smPyr[ s ]->getLDis();
		ostringstream sStr;
		sStr << s;
		string sFn = sStr.str( ) + "_ld.png";
		imwrite( sFn, sDis );
	}
	saveOnePixCost( smPyr, PY_LVL );
#endif
#ifdef USE_MEDIAN_FILTER
	//
	// Median Filter Output
	//
	MeanFilter( lDis, lDis, 3 );
#endif
	duration = static_cast<double>(getTickCount())-duration;
	duration /= cv::getTickFrequency(); // the elapsed time in sec
	printf( "\n--------------------------------------------------------\n" );
	printf( "Total Time: %.2lf s\n", duration );
	printf( "--------------------------------------------------------\n" );

	//
	// Save Output
	//
	imwrite( lDisFn, lDis );
	imwrite( rDisFn, rDis );


	delete [] smPyr;
	delete ccMtd;
	delete caMtd;
	delete ppMtd;
	return 0;
}

#else

int main( int argc, char** argv )
{
	char* imageListL = "stereoDataL.txt";
	char* imageListR = "stereoDataR.txt";
	char* dImageList = "stereoDis.txt";
	char* maxDisList = "stereoDataMaxDis.txt";
	FILE* f1 = fopen(imageListL, "rt");
	FILE* f2 = fopen(imageListR, "rt");
	FILE* f3 = fopen(dImageList, "rt");
	FILE* f4 = fopen(maxDisList, "rt");

	for(int numImg=1; numImg<=15; numImg++)
	{
		printf( "\n\n--------------------------------------------------------\n" );
		printf( "Scale Space Cost Aggregation" );
		printf( "\n--------------------------------------------------------\n" );
		if( !f1  || !f2  || !f3  || !f4 )
		{
			fprintf(stderr, "can not open file %s\n", imageListL );
			return 0;
		}

		char buf1[1024];
		char buf2[1024];
		char buf3[1024];
		char buf4[1024];
		if( !fgets( buf1, sizeof(buf1)-3, f1 ))
			break;
		if( !fgets( buf2, sizeof(buf2)-3, f2 ))
			break;
		if( !fgets( buf3, sizeof(buf3)-3, f3 ))
			break;
		if( !fgets( buf4, sizeof(buf4)-3, f4 ))
			break;
		size_t len = strlen(buf1);
		size_t len2 = strlen(buf2);
		size_t len3 = strlen(buf3);
		size_t len4 = strlen(buf4);

		while( len > 0 && isspace(buf1[len-1]))
			buf1[--len] = '\0';
		if( buf1[0] == '#')
			continue;

		while( len2 > 0 && isspace(buf2[len2-1]))
			buf2[--len2] = '\0';
		if( buf2[0] == '#')
			continue;

		while( len3 > 0 && isspace(buf3[len3-1]))
			buf3[--len3] = '\0';
		if( buf3[0] == '#')
			continue;

		while( len4 > 0 && isspace(buf4[len4-1]))
			buf4[--len4] = '\0';
		if( buf4[0] == '#')
			continue;

		string lFn = buf1;
		string rFn = buf2;
		string lDisFn = buf3;
		int maxDis = int(atoi(buf4)/4);
		
		//Mat lImg = imread( lFn, CV_LOAD_IMAGE_COLOR );
		//Mat rImg = imread( rFn, CV_LOAD_IMAGE_COLOR );
		//namedWindow ("Limage",CV_WINDOW_AUTOSIZE);
		//imshow("Limage",lImg);
		//namedWindow ("Rimage",CV_WINDOW_AUTOSIZE);
		//imshow("Rimage",rImg);
		//waitKey(0);

		
				
		string ccName = "GRD";
		string caName = "GF";
		string ppName = "NP";
		double costAlpha = 0.3;
		int disSc  = 1;
		printf( " Image:%d,maxDis:%d,\n", numImg, maxDis );
		printf( " Load Image:(%s)(%s)\n", lFn, rFn );
		int numImgInquiry;
		printf( "input a number to determine whether continue this image", lFn, rFn );
		scanf("%d",&numImgInquiry);
		if( numImgInquiry == 0)	continue;


		//
		// Load left right image
		//
		//printf( "\n--------------------------------------------------------\n" );
		//printf( "Load Image: (%s) (%s)\n", lFn, rFn );
		//printf( "--------------------------------------------------------\n" );
		Mat lImg = imread( lFn, CV_LOAD_IMAGE_COLOR );
		Mat rImg = imread( rFn, CV_LOAD_IMAGE_COLOR );
		//	namedWindow ("Limage",CV_WINDOW_AUTOSIZE);
		//	imshow("Limage",lImg);
		if( !lImg.data || !rImg.data ) {
			printf( "Error: can not open image\n" );
			printf( "\nPress any key to continue...\n" );
			getchar();
			return -1;
		}
		// set image format
		cvtColor( lImg, lImg, CV_BGR2RGB );
		cvtColor( rImg, rImg, CV_BGR2RGB );
		lImg.convertTo( lImg, CV_64F, 1 / 255.0f );
		rImg.convertTo( rImg, CV_64F,  1 / 255.0f );

		// time
		double duration;
		duration = static_cast<double>(getTickCount());

		//
		// Stereo Match at each pyramid
		//
		int PY_LVL = 3;
		// build pyramid and cost volume
		Mat lP = lImg.clone();
		Mat rP = rImg.clone();
		SSCA** smPyr = new SSCA*[ PY_LVL ];
		CCMethod* ccMtd = getCCType( ccName );
		CAMethod* caMtd = getCAType( caName );
		int r = 9;
		for( int p = 0; p < PY_LVL; p ++ ) 
		{
			if( maxDis < 5 ) 
			{
				PY_LVL = p;
				break;
			}
			printf( "\n\tPyramid: %d:", p );
			smPyr[ p ] = new SSCA( lP, rP, maxDis, disSc );


			smPyr[ p ]->CostCompute( ccMtd );

			//if( p== 0 ) {
			//		smPyr[ 0 ]->saveCostVol( "CCGRD.txt" );
			//}

			//smPyr[ p ]->CostAggre( caMtd  );
		
			printf( "\nCost Aggregation-" );
			for( int d = 1; d < maxDis; d ++ ) 
			{
				printf( "-c-a" );
				smPyr[ p ]->costVol[ d ] = GuidedFilter( lImg, smPyr[ p ]->costVol[ d ], r );
			}
			r=r+9;
		}
		printf( "\n--------------------------------------------------------\n" );
		printf( "\n Cost Aggregation in Scale Space\n" );
		printf( "\n--------------------------------------------------------\n" );
		// new method
		mySolveAll( smPyr, PY_LVL, costAlpha );

		//
		// Match + Postprocess
		//
		smPyr[ 0 ]->Match();
		smPyr[ 1 ]->Match();
		smPyr[ 2 ]->Match();
		//smPyr[ 0 ]->PostProcess( ppMtd );
		Mat lDis0 = smPyr[ 0 ]->getLDis();
		Mat lDis1 = smPyr[ 1 ]->getLDis();
		Mat lDis2 = smPyr[ 2 ]->getLDis();
		//Mat lDis = smPyr[ 0 ]->getLDis();

	/*#ifdef _DEBUG
		for( int s = 0; s < PY_LVL; s ++ ) {
			smPyr[ s ]->Match();
			Mat sDis = smPyr[ s ]->getLDis();
			ostringstream sStr;
			sStr << s;
			string sFn = sStr.str( ) + "_ld.png";
			imwrite( sFn, sDis );
		}
		saveOnePixCost( smPyr, PY_LVL );
	#endif*/
	#ifdef USE_MEDIAN_FILTER
		//
		// Median Filter Output
		//
		MeanFilter( lDis, lDis, 3 );
	#endif
		duration = static_cast<double>(getTickCount())-duration;
		duration /= cv::getTickFrequency(); // the elapsed time in sec
		printf( "\n--------------------------------------------------------\n" );
		printf( "Total Time: %.2lf s\n", duration );
		printf( "--------------------------------------------------------\n" );
		//
		// Save Output
		//
		imwrite( "Ldis0.png", lDis0 );
		imwrite( "Ldis1.png", lDis1 );
		imwrite( "Ldis2.png", lDis2 );
		imwrite( lDisFn, lDis1 );
		//imwrite( lDisFn, lDis );

		//
		// For drawing - save cost volume
		//
		//string costFn = "";
		//if( costAlpha > 0.0 ) {
		//	costFn = "S_" + caName + ".txt";
		//} else {
		//	costFn = caName + ".txt";
		//}

		//smPyr[ 0 ]->saveCostVol( costFn.c_str() );

		delete [] smPyr;
		delete ccMtd;
		delete caMtd;
	}
	fclose(f1);
	fclose(f2);
	fclose(f3);
	fclose(f4);
	return 0;
}



// for test time

//int main( int argc, char** argv )
//{
//	printf( "Scale Space Cost Aggregation\n" );
//	if( argc != 10 ) {
//		printf( "Usage: [CC_METHOD] [CA_METHOD] [PP_METHOD] [C_ALPHA] [lImg] [rImg] [lDis] [maxDis] [disSc]\n" );
//		printf( "\nPress any key to continue...\n" );
//		getchar();
//		return -1;
//	}
//	string ccName = argv[ 1 ];
//	string caName = argv[ 2 ];
//	string ppName = argv[ 3 ];
//	double costAlpha = atof( argv[ 4 ] );
//	string lFn = argv[ 5 ];
//	string rFn = argv[ 6 ];
//	string lDisFn = argv[ 7 ];
//	int maxDis = atoi( argv[ 8 ] );
//	int disSc  = atoi( argv[ 9 ] );
//	//
//	// Load left right image
//	//
//	printf( "\n--------------------------------------------------------\n" );
//	printf( "Load Image: (%s) (%s)\n", argv[ 5 ], argv[ 6 ] );
//	printf( "--------------------------------------------------------\n" );
//	Mat lImg = imread( lFn, CV_LOAD_IMAGE_COLOR );
//	Mat rImg = imread( rFn, CV_LOAD_IMAGE_COLOR );
//	if( !lImg.data || !rImg.data ) {
//		printf( "Error: can not open image\n" );
//		printf( "\nPress any key to continue...\n" );
//		getchar();
//		return -1;
//	}
//	// set image format
//	cvtColor( lImg, lImg, CV_BGR2RGB );
//	cvtColor( rImg, rImg, CV_BGR2RGB );
//	lImg.convertTo( lImg, CV_64F, 1 / 255.0f );
//	rImg.convertTo( rImg, CV_64F,  1 / 255.0f );
//
//	// time
//	double duration;
//	duration = static_cast<double>(getTickCount());
//
//	//
//	// Stereo Match at each pyramid
//	//
//	int PY_LVL = 1;
//	// build pyramid and cost volume
//	Mat lP = lImg.clone();
//	Mat rP = rImg.clone();
//	SSCA** smPyr = new SSCA*[ PY_LVL ];
//	CCMethod* ccMtd = getCCType( ccName );
//	CAMethod* caMtd = getCAType( caName );
//	PPMethod* ppMtd = getPPType( ppName );
//	for( int p = 0; p < PY_LVL; p ++ ) {
//		if( maxDis < 5 ) {
//			PY_LVL = p;
//			break;
//		}
//		printf( "\n\tPyramid: %d:", p );
//		smPyr[ p ] = new SSCA( lP, rP, maxDis, disSc );
//
//
//		smPyr[ p ]->CostCompute( ccMtd );
//
//		smPyr[ p ]->CostAggre( caMtd  );
//		// pyramid downsample
//		maxDis = maxDis / 2 + 1;
//		disSc  *= 2;
//		pyrDown( lP, lP );
//		pyrDown( rP, rP );
//	}
//	printf( "\n--------------------------------------------------------\n" );
//	printf( "\n Cost Aggregation in Scale Space\n" );
//	printf( "\n--------------------------------------------------------\n" );
//	// new method
//	// SolveAll( smPyr, PY_LVL, costAlpha );
//
//	// old method
//	//for( int p = PY_LVL - 2 ; p >= 0; p -- ) {
//	//	smPyr[ p ]->AddPyrCostVol( smPyr[ p + 1 ], costAlpha );
//	//}
//
//	//
//	// Match + Postprocess
//	//
//	smPyr[ 0 ]->Match();
//	smPyr[ 0 ]->PostProcess( ppMtd );
//	Mat lDis = smPyr[ 0 ]->getLDis();
//
//#ifdef _DEBUG
//	for( int s = 0; s < PY_LVL; s ++ ) {
//		smPyr[ s ]->Match();
//		Mat sDis = smPyr[ s ]->getLDis();
//		ostringstream sStr;
//		sStr << s;
//		string sFn = sStr.str( ) + "_ld.png";
//		imwrite( sFn, sDis );
//	}
//	saveOnePixCost( smPyr, PY_LVL );
//#endif
//#ifdef USE_MEDIAN_FILTER
//	//
//	// Median Filter Output
//	//
//	MeanFilter( lDis, lDis, 3 );
//#endif
//	duration = static_cast<double>(getTickCount())-duration;
//	duration /= cv::getTickFrequency(); // the elapsed time in sec
//	printf( "\n--------------------------------------------------------\n" );
//	printf( "Total Time: %.2lf s\n", duration );
//	printf( "--------------------------------------------------------\n" );
//
//	//
//	// Save Output
//	//
//	imwrite( lDisFn, lDis );
//
//	delete [] smPyr;
//	delete ccMtd;
//	delete caMtd;
//	delete ppMtd;
//	return 0;
//}
//

#endif
//
//int main( int argc, char** argv )
//{
//	printf( "Normal Cost Aggregation\n" );
//	if( argc != 9 ) {
//		printf( "Usage: [CC_METHOD] [CA_METHOD] [PP_METHOD] [lImg] [rImg] [lDis] [maxDis] [disSc]\n" );
//		printf( "\nPress any key to continue...\n" );
//		getchar();
//		return -1;
//	}
//	string ccName = argv[ 1 ];
//	string caName = argv[ 2 ];
//	string ppName = argv[ 3 ];
//	string lFn = argv[ 4 ];
//	string rFn = argv[ 5 ];
//	string lDisFn = argv[ 6 ];
//	int maxDis = atoi( argv[ 7 ] );
//	int disSc  = atoi( argv[ 8 ] );
//	//
//	// Load left right image
//	//
//	printf( "\n--------------------------------------------------------\n" );
//	printf( "Load Image: (%s) (%s)\n", argv[ 4 ], argv[ 5 ] );
//	printf( "--------------------------------------------------------\n" );
//	Mat lImg = imread( lFn, CV_LOAD_IMAGE_COLOR );
//	Mat rImg = imread( rFn, CV_LOAD_IMAGE_COLOR );
//	if( !lImg.data || !rImg.data ) {
//		printf( "Error: can not open image\n" );
//		printf( "\nPress any key to continue...\n" );
//		getchar();
//		return -1;
//	}
//	// set image format
//	cvtColor( lImg, lImg, CV_BGR2RGB );
//	cvtColor( rImg, rImg, CV_BGR2RGB );
//	lImg.convertTo( lImg, CV_64F, 1 / 255.0f );
//	rImg.convertTo( rImg, CV_64F,  1 / 255.0f );
//
//	//
//	// Stereo Match
//	//
//
//	SSCA* sm = new SSCA( lImg, rImg, maxDis, disSc );
//	CCMethod* ccMtd = getCCType( ccName );
//	CAMethod* caMtd = getCAType( caName );
//	PPMethod* ppMtd = getPPType( ppName );
//	double duration;
//	duration = static_cast<double>(getTickCount());
//
//
//	sm->CostCompute( ccMtd );
//
//	sm->CostAggre( caMtd );
//
//	sm->Match();
//
//	sm->PostProcess( ppMtd );
//
//	duration = static_cast<double>(getTickCount())-duration;
//	duration /= cv::getTickFrequency(); // the elapsed time in sec
//	printf( "\n--------------------------------------------------------\n" );
//	printf( "Total Time: %.2lf s\n", duration );
//	printf( "--------------------------------------------------------\n" );
//	//
//	// Save output
//	//
//	Mat lDis = sm->getLDis();
//#ifdef USE_MEDIAN_FILTER
//	//
//	// Median Filter Output
//	//
//	MeanFilter( lDis, lDis, 3 );
//#endif
//	imwrite( lDisFn, lDis );
//
//	return 0;
//}