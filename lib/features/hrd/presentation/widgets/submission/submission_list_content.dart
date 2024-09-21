import 'package:akib_pos/common/app_colors.dart';
import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/features/hrd/data/models/submission.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SubmissionListContent extends StatelessWidget {
  final Submission submission;

  const SubmissionListContent({Key? key, required this.submission}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Submission Date and Type
          _buildHeader(submission.submissionDate, submission.type),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name and Role
               Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                   Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       _buildType(submission.type),
                        const SizedBox(height: 4),
                        Text(submission.name, style: AppTextStyle.headline5),
                        const SizedBox(height: 4),
                        Text(submission.role, style: AppTextStyle.caption),
                        const SizedBox(height: 8),
                     ],
                   ),
                   OutlinedButton(
                      onPressed: () {
                        // Handle detail button press
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.primaryMain),
                        shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                      ),
                      child: Text('Detail', style: TextStyle(color: AppColors.primaryMain)),
                    ),
                 ],
               ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 8,horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: AppColors.textGrey100
                  ),
                  child: Column(
                    
                    children: [
                  _buildSubmissionDetails(submission.details),
                  const SizedBox(height: 8),
                  _buildApprovalStatus(submission.approverName, submission.approvalStatus),
                    ],
                  ),
                ),
                
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildType(String type){
   Color textColor,backgroundColor;
    if (type == 'cuti') {
      textColor = AppColors.secondaryMain;
      backgroundColor = AppColors.secondaryMain.withOpacity(0.1); 
    } else if (type == 'izin') {
      textColor = AppColors.warningMain;
       backgroundColor = AppColors.warningMain.withOpacity(0.1); 
    } else {
      textColor = AppColors.successMain;
       backgroundColor = AppColors.successMain.withOpacity(0.1); 
    }
    return  Container(
      padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: backgroundColor
      ),
      child: Text(submission.submissionType, style: AppTextStyle.caption.copyWith(color: textColor)),
    );
  }

  Widget _buildHeader(String submissionDate, String type) {
    // Determine color based on submission type
 

    return Container(
      padding:  EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        // color: AppColors.primaryMain,
        color: AppColors.primaryMain,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Pengajuan: $submissionDate',
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmissionDetails(List<Detail> details) {
    return Column(
      children: details
          .map((detail) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(detail.key, style: AppTextStyle.caption.copyWith(color: AppColors.textGrey600)),
                    Text(detail.value, style: AppTextStyle.caption.copyWith(fontWeight: FontWeight.bold)),
                  ],
                ),
              ))
          .toList(),
    );
  }

  Widget _buildApprovalStatus(String approverName, String approvalStatus) {
    // Choose icon based on approval status
    String assetPath;
    if (approvalStatus == 'approved') {
      assetPath = 'assets/icons/hrd/ic_approved.svg';
    } else if (approvalStatus == 'pending') {
      assetPath = 'assets/icons/hrd/ic_clock_pending.svg';
    } else {
      assetPath = 'assets/icons/hrd/ic_rejected.svg';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Status Persetujuan', style: AppTextStyle.caption.copyWith(color: AppColors.textGrey600)),
        SizedBox(height: 4,),
        Row(
          children: [
            Text("${approverName} : "  , style: AppTextStyle.caption.copyWith(color: Colors.black)),
            const SizedBox(width: 4),
            SvgPicture.asset(
              assetPath,
            ),
          ],
        ),
      ],
    );
  }
}
