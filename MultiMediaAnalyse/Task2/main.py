import cv2


def SIFT(imgname1, imgname2):
    sift = cv2.xfeatures2d.SIFT_create()

    img1 = cv2.imread(imgname1)
    img2 = cv2.imread(imgname2)
    kp1, des1 = sift.detectAndCompute(img1, None)
    kp2, des2 = sift.detectAndCompute(img2, None)

    FLANN_INDEX_KDTREE = 0
    index_params = dict(algorithm=FLANN_INDEX_KDTREE, trees=5)
    search_params = dict(checks=50)
    flann = cv2.FlannBasedMatcher(index_params, search_params)
    matches = flann.knnMatch(des1,des2,k=2)

    good = []
    for m,n in matches:
        if m.distance < 0.70*n.distance:
            good.append([m])

    img3 = cv2.drawMatchesKnn(img1,kp1,img2,kp2,good,None,flags=2)
    return img3

def ORB(imgname1, imgname2):
    orb = cv2.ORB_create()

    img1 = cv2.imread(imgname1)
    img2 = cv2.imread(imgname2)
    kp1, des1 = orb.detectAndCompute(img1,None)
    kp2, des2 = orb.detectAndCompute(img2,None)

    bf = cv2.BFMatcher()
    matches = bf.knnMatch(des1,des2, k=2)
    good = []
    for m,n in matches:
        if m.distance < 0.8*n.distance:
            good.append([m])

    img3 = cv2.drawMatchesKnn(img1,kp1,img2,kp2,good,None,flags=2)
    return img3


if __name__ == '__main__':
    imgname1 = '1.jpg'
    imgname2 = '2.jpg'

    img3 = SIFT(imgname1, imgname2)
    img4 = ORB(imgname1, imgname2)
    cv2.imshow("SIFT", img3)
    cv2.imwrite("sift.jpg",img3)
    cv2.imshow("ORB", img4)
    cv2.imwrite("orb.jpg",img4)
    cv2.waitKey(0)
    cv2.destroyAllWindows()

