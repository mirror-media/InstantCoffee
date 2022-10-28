import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/models/election/candidate.dart';
import 'package:readr_app/models/election/municipality.dart';

class MunicipalityItem extends StatelessWidget {
  final Municipality municipality;
  const MunicipalityItem(this.municipality, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat("###,###,###,##0");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          municipality.name,
          style: const TextStyle(
            fontSize: 16,
            color: Color.fromRGBO(191, 50, 132, 1),
            fontWeight: FontWeight.w700,
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.only(top: 12, bottom: 17),
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              Candidate item = municipality.candidates[index];
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '${item.number} ${item.name}',
                        style: const TextStyle(
                          color: Color.fromRGBO(74, 74, 74, 1),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      if (partyLogoMap[item.party] != null)
                        SvgPicture.asset(
                          partyLogoMap[item.party]!,
                          width: 16,
                          height: 16,
                        )
                      else
                        Text(
                          item.party,
                          style: const TextStyle(
                            color: Color.fromRGBO(74, 74, 74, 0.75),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      const SizedBox(
                        width: 8.3,
                      ),
                      if (item.elected)
                        SvgPicture.asset(
                          electedSvg,
                          width: 16,
                          height: 16,
                        ),
                    ],
                  ),
                  LinearPercentIndicator(
                    key: Key(item.name + item.number),
                    percent: item.percentageOfVotesObtained / 100,
                    center: Row(
                      children: [
                        const SizedBox(
                          width: 6.68,
                        ),
                        Text(
                          numberFormat.format(item.votes),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${item.percentageOfVotesObtained.toStringAsFixed(1)}%',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color.fromRGBO(74, 74, 74, 1),
                          ),
                        ),
                        const SizedBox(
                          width: 7.15,
                        ),
                      ],
                    ),
                    lineHeight: 24,
                    animation: true,
                    backgroundColor: Colors.black12,
                    progressColor: const Color.fromRGBO(5, 79, 119, 1),
                    padding: const EdgeInsets.only(top: 5),
                  ),
                ],
              );
            },
            itemCount: municipality.candidates.length > 3
                ? 3
                : municipality.candidates.length,
            separatorBuilder: (BuildContext context, int index) =>
                const SizedBox(height: 8),
          ),
        ),
      ],
    );
  }
}
