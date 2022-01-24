import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/tagPage/cubit.dart';
import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/models/tag.dart';
import 'package:readr_app/pages/tag/tagWidget.dart';

class TagPage extends StatefulWidget {
  final Tag tag;
  const TagPage({
    required this.tag,
  });

  @override
  _TagPageState createState() => _TagPageState();
}

class _TagPageState extends State<TagPage> {
  late Tag _tag;

  @override
  void initState() {
    _tag = widget.tag;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(context),
      backgroundColor: Colors.white,
      body: BlocProvider(
        create: (context) => TagPageCubit(),
        child: TagWidget(_tag),
      ),
    );
  }

  PreferredSizeWidget _buildBar(BuildContext context) {
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle.light,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      backgroundColor: appColor,
      centerTitle: true,
      title: Text(
        _tag.name,
        style: const TextStyle(color: Colors.white, fontSize: 20),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
