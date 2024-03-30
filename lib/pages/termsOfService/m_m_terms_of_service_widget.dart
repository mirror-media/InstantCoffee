// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:readr_app/blocs/storyPage/news/bloc.dart';
// import 'package:readr_app/models/story_res.dart';
// import 'package:readr_app/pages/termsOfService/terms_of_service_widget.dart';
// import 'package:readr_app/widgets/logger.dart';
//
// import '../../data/enum/story_status.dart';
//
// class MMTermsOfServiceWidget extends StatefulWidget {
//   @override
//   _MMTermsOfServiceWidgetState createState() => _MMTermsOfServiceWidgetState();
// }
//
// class _MMTermsOfServiceWidgetState extends State<MMTermsOfServiceWidget>
//     with Logger {
//   @override
//   void initState() {
//     super.initState();
//     _fetchPublishedStoryBySlug(
//         context.read<StoryBloc>().currentStorySlug, false);
//   }
//
//   _fetchPublishedStoryBySlug(String storySlug, bool isMemberCheck) {
//     context
//         .read<StoryBloc>()
//         .add(FetchPublishedStoryBySlug(storySlug, isMemberCheck));
//   }
//
//   _delayNavigatorPop() async {
//     await Future.delayed(const Duration(milliseconds: 0));
//     Navigator.of(context).pop();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<StoryBloc, StoryState>(
//         builder: (BuildContext context, StoryState state) {
//       switch (state.status) {
//         case StoryStatus.error:
//           final error = state.errorMessages;
//           debugLog('StoryError: ${error.message}');
//           _delayNavigatorPop();
//           return Container();
//         case StoryStatus.loaded:
//           StoryRes storyRes = state.storyRes!;
//
//           if (storyRes.story.apiData.isEmpty) {
//             _delayNavigatorPop();
//           }
//
//           // change font size
//           for (int i = 0; i < storyRes.story.apiData.length; i++) {
//             if (storyRes.story.apiData[i].type == 'header-two') {
//               storyRes.story.apiData[i].type = 'unstyled';
//             }
//           }
//           for (int i = 0; i < storyRes.story.trimmedApiData.length; i++) {
//             if (storyRes.story.trimmedApiData[i].type == 'header-two') {
//               storyRes.story.trimmedApiData[i].type = 'unstyled';
//             }
//           }
//
//           return Padding(
//             padding: const EdgeInsets.only(left: 24, right: 24),
//             child: TermsOfServiceWidget(
//               story: storyRes.story,
//             ),
//           );
//         default:
//           // state is Init, Loading
//           return _loadingWidget();
//       }
//     });
//   }
//
//   Widget _loadingWidget() {
//     return const Center(
//       child: CircularProgressIndicator(),
//     );
//   }
// }
