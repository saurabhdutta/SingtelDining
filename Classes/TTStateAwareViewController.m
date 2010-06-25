#import "TTStateAwareViewController.h" 

@implementation TTStateAwareViewController 
@synthesize emptyView = _emptyView, loadingView = _loadingView, 
errorView = _errorView, overlayView = _overlayView; 
/////////////////////////////////////////////////////////////////////////// //////////////////////// 
// Private 
- (void)dealloc 
{ 
  TT_RELEASE_SAFELY( _emptyView ); 
  TT_RELEASE_SAFELY( _loadingView ); 
  TT_RELEASE_SAFELY( _errorView ); 
  TT_RELEASE_SAFELY( _overlayView ); 
  [super dealloc]; 
} 

/////////////////////////////////////////////////////////////////////////// //////////////////////// 
// TTStateAwareViewController 
- (NSString*)titleForLoading 
{ 
  return nil; 
} 

- (UIImage*)imageForEmpty 
{ 
  return nil; 
} 

- (NSString*)titleForEmpty 
{ 
  return nil; 
} 

- (NSString*)subtitleForEmpty 
{ 
  return nil; 
} 

- (UIImage*)imageForError:(NSError*)error 
{ 
  return nil; 
} 

- (NSString*)titleForError:(NSError*)error 
{ 
  return nil; 
} 

- (NSString*)subtitleForError:(NSError*)error 
{ 
  return nil; 
} 

/////////////////////////////////////////////////////////////////////////////////////////////////// 
// Private 
- (CGRect)rectForOverlayView 
{ 
  return self.view.frame; 
} 

- (void)addToOverlayView:(UIView*)view 
{ 
  if (!_overlayView) 
  { 
    CGRect frame = [self rectForOverlayView]; 
    _overlayView = [[UIView alloc] initWithFrame:frame]; 
    _overlayView.autoresizesSubviews = YES; 
    _overlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin; 
    [self.view addSubview:_overlayView]; 
  } 
  view.frame = _overlayView.bounds; 
  view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight; 
  [_overlayView addSubview:view]; 
} 

- (void)resetOverlayView 
{ 
  if (_overlayView && !_overlayView.subviews.count) 
  { 
    [_overlayView removeFromSuperview]; 
    TT_RELEASE_SAFELY(_overlayView); 
  } 
} 

- (void)layoutOverlayView 
{ 
  if (_overlayView) 
  { 
    _overlayView.frame = [self rectForOverlayView]; 
  } 
} 

/////////////////////////////////////////////////////////////////////////// //////////////////////// 
// Public 
- (void)setLoadingView:(UIView*)view 
{ 
  if (view != _loadingView) 
  { 
    if (_loadingView) 
    { 
      [_loadingView removeFromSuperview]; 
      TT_RELEASE_SAFELY(_loadingView); 
    } 
    _loadingView = [view retain]; 
    if (_loadingView) 
    { 
      [self addToOverlayView:_loadingView]; 
    } 
    else 
    { 
      [self resetOverlayView]; 
    } 
  } 
} 

- (void)setErrorView:(UIView*)view 
{ 
  if (view != _errorView) 
  { 
    if (_errorView) 
    { 
      [_errorView removeFromSuperview]; 
      TT_RELEASE_SAFELY(_errorView); 
    } 
    _errorView = [view retain]; 
    if (_errorView) 
    { 
      [self addToOverlayView:_errorView]; 
    } 
    else 
    { 
      [self resetOverlayView]; 
    } 
  } 
} 

- (void)setEmptyView:(UIView*)view 
{ 
  if (view != _emptyView) 
  { 
    if (_emptyView) 
    { 
      [_emptyView removeFromSuperview]; 
      TT_RELEASE_SAFELY(_emptyView); 
    } 
    _emptyView = [view retain]; 
    if (_emptyView) 
    { 
      [self addToOverlayView:_emptyView]; 
    } 
    else 
    { 
      [self resetOverlayView]; 
    } 
  } 
} 

/////////////////////////////////////////////////////////////////////////// //////////////////////// 
// TTModelViewController 
- (void)showLoading:(BOOL)show 
{ 
  if (show) 
  { 
    if (!self.model.isLoaded || ![self canShowModel]) 
    { 
      NSString* title = [self titleForLoading]; 
      if (title.length) 
      { 
        TTActivityLabel* label = [[[TTActivityLabel alloc] initWithStyle:TTActivityLabelStyleWhiteBox] autorelease]; 
        label.text = title; 
        label.backgroundColor = self.view.backgroundColor; 
        self.loadingView = label; 
      } 
    } 
  } 
  else 
  { 
    self.loadingView = nil; 
  } 
} 

- (void)showError:(BOOL)show 
{ 
  if (show) 
  { 
    if (!self.model.isLoaded || ![self canShowModel]) 
    { 
      NSString* title = [self titleForError:_modelError]; 
      NSString* subtitle = [self subtitleForError:_modelError]; 
      UIImage* image = [self imageForError:_modelError]; 
      if ( title.length || subtitle.length || image ) 
      { 
        TTErrorView* errorView = [[[TTErrorView alloc] initWithTitle:title subtitle:subtitle image:image] autorelease]; 
        errorView.backgroundColor = self.view.backgroundColor; 
        self.errorView = errorView; 
      } 
      else 
      { 
        self.errorView = nil; 
      } 
    } 
  } 
  else 
  { 
    self.errorView = nil; 
  } 
} 

- (void)showEmpty:(BOOL)show 
{ 
  if (show) 
  { 
    NSString* title = [self titleForEmpty]; 
    NSString* subtitle = [self subtitleForEmpty]; 
    UIImage* image = [self imageForEmpty]; 
    if (title.length || subtitle.length || image) 
    { 
      TTErrorView* errorView = [[[TTErrorView alloc] initWithTitle:title subtitle:subtitle image:image] autorelease]; 
      errorView.backgroundColor = self.view.backgroundColor; 
      self.emptyView = errorView; 
    } 
    else 
    { 
      self.emptyView = nil; 
    } 
  } 
  else 
  { 
    self.emptyView = nil; 
  } 
} 

@end